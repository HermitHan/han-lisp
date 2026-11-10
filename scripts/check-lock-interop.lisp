;;;; Default peers: SBCL for ECL and CCL; ECL for SBCL and LispWorks.
;;;; HAN_LOCK_PEER_IMPL selects sbcl, ecl or ccl. HAN_LOCK_PEER sets its path.
(require :asdf)
(let ((root (uiop:pathname-parent-directory-pathname
             (uiop:pathname-directory-pathname *load-truename*))))
  (asdf:load-asd (merge-pathnames "han.asd" root))
  (asdf:load-system "han"))

(defpackage #:han-lock-probe (:use #:cl))
(in-package #:han-lock-probe)

(defun peer-command (script)
  (let* ((implementation (or (uiop:getenv "HAN_LOCK_PEER_IMPL")
                             #+(or ecl ccl) "sbcl" #-(or ecl ccl) "ecl"))
         (name (or (uiop:getenv "HAN_LOCK_PEER") implementation))
         (program (or (han.host:find-executable name)
                      (error "Cannot find lock probe peer ~S." name)))
         (options (cond ((string-equal implementation "sbcl")
                         '("--noinform" "--no-sysinit" "--no-userinit" "--disable-debugger" "--script"))
                        ((string-equal implementation "ecl") '("-norc" "-shell"))
                        ((string-equal implementation "ccl") '("--no-init" "--batch" "--quiet" "--load"))
                        (t (error "Unknown lock probe peer implementation ~S." implementation)))))
    (append (list program) options (list (namestring script)))))

(defun check-parent-contention (command file ready)
  (let ((peer (uiop:launch-program command :output :interactive :error-output :interactive))
        (deadline (+ (get-internal-real-time) (* 60 internal-time-units-per-second))))
    (unwind-protect
         (progn
           ;; The peer writes its marker only after acquiring the same lock.
           (loop until (with-open-file (in ready) (read-char in nil))
                 do (unless (uiop:process-alive-p peer)
                      (error "Lock peer exited before acquiring ~A." file))
                    (when (>= (get-internal-real-time) deadline)
                      (error "Timed out waiting for lock peer ~A." (first command)))
                    (sleep 0.025))
           (assert (handler-case
                       (progn (han.host:call-with-exclusive-file-lock file (constantly nil)
                                                                      :timeout 1/10)
                              nil)
                     (simple-error (e) (search "Timed out" (princ-to-string e)))))
           (format t "~&PASS parent contended on lock held by peer=~A~%" (first command)))
      (when (uiop:process-alive-p peer) (uiop:terminate-process peer :urgent t))
      (uiop:wait-process peer))))

(defun call-peer (file action &optional ready)
  (uiop:with-temporary-file (:stream out :pathname script :type "lisp")
    (write-line "(require :asdf)" out)
    (format out "(asdf:load-asd ~S)~%(asdf:load-system \"han\")~%"
            (asdf:system-source-file "han"))
    (ecase action
      (:expect-contention
       (format out "(handler-case (han.host:call-with-exclusive-file-lock ~S
                     (lambda () (han.host:quit 2)) :timeout 1/10)
                     (simple-error (e) (han.host:quit
                       (if (search \"Timed out\" (princ-to-string e)) 0 3))))" file))
      (:hold
       (format out "(han.host:call-with-exclusive-file-lock ~S (lambda ()
                      (with-open-file (out ~S :direction :output :if-exists :append)
                        (write-char #\\1 out))
                      (sleep 60)
                      (han.host:quit 4)) :timeout 0)" file ready))
      (:exit-while-holding
       (format out "(han.host:call-with-exclusive-file-lock ~S
                     (lambda () (han.host:process-wait
                       (han.host:run-program \"/bin/kill\" :arguments
                          (list \"-KILL\" (write-to-string (han.host:current-process-id)))))
                       (error \"Peer survived SIGKILL.\")) :timeout 0)" file)))
    :close-stream
    (let ((command (peer-command script)))
      (when (eq action :hold)
        (return-from call-peer (check-parent-contention command file ready)))
      (multiple-value-bind (stdout stderr code)
          (han.host:run-program-sync command)
        (unless (eql code (ecase action (:expect-contention 0)
                                        (:exit-while-holding #+sbcl 9 #-sbcl 137)))
          (error "~A peer ~A returned ~A~%~A~%~A" action (first command) code stdout stderr))
        (format t "~&PASS ~A peer=~A status=~D~%" action (first command) code)))))

(uiop:with-temporary-file (:pathname file)
  (han.host:call-with-exclusive-file-lock file (lambda () (call-peer file :expect-contention)))
  (uiop:with-temporary-file (:pathname ready)
    (call-peer file :hold ready))
  (call-peer file :exit-while-holding)
  (assert (equal '(:acquired :again)
                 (multiple-value-list
                  (han.host:call-with-exclusive-file-lock
                   file (lambda () (values :acquired :again)) :timeout 0))))
  (format t "~&PASS reacquired lock after peer exit on ~A ~A~%"
          (lisp-implementation-type) (lisp-implementation-version)))
