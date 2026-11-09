;;;; Load this file in either implementation. The peer is ECL for SBCL and
;;;; LispWorks, or SBCL for ECL. HAN_LOCK_PEER can name its exact executable.
(require :asdf)
(let ((root (uiop:pathname-parent-directory-pathname
             (uiop:pathname-directory-pathname *load-truename*))))
  (asdf:load-asd (merge-pathnames "han.asd" root))
  (asdf:load-system "han"))

(defpackage #:han-lock-probe (:use #:cl))
(in-package #:han-lock-probe)

(defun call-peer (file action)
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
      (:exit-while-holding
       (format out "(han.host:call-with-exclusive-file-lock ~S
                     (lambda () (han.host:process-wait
                       (han.host:run-program \"/bin/kill\" :arguments
                          (list \"-KILL\" (write-to-string (han.host:current-process-id)))))
                       (error \"Peer survived SIGKILL.\")) :timeout 0)" file)))
    :close-stream
    (let* ((name (or (uiop:getenv "HAN_LOCK_PEER") #+ecl "sbcl" #-ecl "ecl"))
           (exe (or (han.host:find-executable name)
                    (error "Cannot find lock probe peer ~S." name))))
      (multiple-value-bind (stdout stderr code)
          (han.host:run-program-sync
           (append (list exe) #+ecl '("--noinform" "--no-sysinit" "--no-userinit"
                                      "--disable-debugger" "--script")
                              #-ecl '("-norc" "-shell") (list (namestring script))))
        (unless (eql code (ecase action (:expect-contention 0)
                                        (:exit-while-holding #+sbcl 9 #-sbcl 137)))
          (error "~A peer ~A returned ~A~%~A~%~A" action exe code stdout stderr))
        (format t "~&PASS ~A peer=~A status=~D~%" action exe code)))))

(uiop:with-temporary-file (:pathname file)
  (han.host:call-with-exclusive-file-lock file (lambda () (call-peer file :expect-contention)))
  (call-peer file :exit-while-holding)
  (assert (equal '(:acquired :again)
                 (multiple-value-list
                  (han.host:call-with-exclusive-file-lock
                   file (lambda () (values :acquired :again)) :timeout 0))))
  (format t "~&PASS reacquired lock after peer exit on ~A ~A~%"
          (lisp-implementation-type) (lisp-implementation-version)))
