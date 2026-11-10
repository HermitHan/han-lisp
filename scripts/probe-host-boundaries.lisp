;;;; Invoked by check-host-boundaries.py with local network fixtures.
(require :asdf)
(let ((checkout (uiop:pathname-parent-directory-pathname
                 (uiop:pathname-directory-pathname *load-truename*))))
  (asdf:load-asd (merge-pathnames "han.asd" checkout))
  (asdf:load-system "han"))

(defpackage #:han-boundary-probe (:use #:cl))
(in-package #:han-boundary-probe)

;; The Python-generated Listener loader binds these paths only while loading
;; this file. The Listener keeps running when a case succeeds or signals.
(defvar cl-user::*han-probe-listener-files* nil)

(defun check-curl-failure (case)
  (let* ((name (han.json:get-json case "name"))
         (command (coerce (han.json:get-json case "argv") 'list))
         (expected-code (han.json:get-json case "code"))
         (results (multiple-value-list (han.os:run-program command))))
    (destructuring-bind (out err code) results
      (unless (and (equal out "") (stringp err) (plusp (length err))
                   (eql code expected-code))
        (error "~A expected empty stdout, a diagnostic, and exit ~D; got ~S"
               name expected-code results))
      (let ((condition (handler-case
                           (progn (han.os:run-program command :ignore-error-status nil) nil)
                         (error (c) c))))
        (unless (typep condition 'simple-error)
          (error "~A expected SIMPLE-ERROR in strict mode; got ~S" name condition))
        (han.json:json-object
         (cons "name" name) (cons "stdout" out) (cons "stderr" err) (cons "code" code)
         (cons "strict_type" (symbol-name (class-name (class-of condition))))
         (cons "strict_message" (princ-to-string condition)))))))

(defun observe-invalid-utf8 (name octets)
  ;; The external-format decoder owns malformed input. Record what it did so
  ;; that a decoding condition, a JSON condition and replacement stay distinct.
  (uiop:with-temporary-file (:pathname file)
    (with-open-file (out file :direction :output :if-exists :supersede
                              :element-type '(unsigned-byte 8))
      (write-sequence octets out))
    (handler-case (han.json:read-json-file file)
      (error (c)
        (format t "~&OBS ~A condition=~S json-error=~S~%"
                name (class-name (class-of c)) (typep c 'han.json:json-error))
        c)
      (:no-error (value)
        (check-type value string)
        (let ((scalars (map 'list #'han.host:char-unicode-scalar value)))
          (format t "~&OBS ~A returned=~S~%" name scalars)
          scalars)))))

(defun run-probe (cases-file results-file)
  (format t "~&Runtime: ~A ~A on ~A~%" (lisp-implementation-type)
          (lisp-implementation-version) (software-type))
  (let ((cases (han.json:read-json-file cases-file)))
    (han.json:write-json-file results-file (map 'vector #'check-curl-failure cases)))
  (let ((bad (observe-invalid-utf8 "BAD-CONTINUATION" #(#x22 #xC3 #x28 #x22)))
        (short (observe-invalid-utf8 "TRUNCATED-AT-EOF" #(#x22 #xF0 #x9F))))
    (declare (ignorable bad short))
    #+ccl
    (progn (assert (equal '(#xFFFD) bad))
           (assert (typep short 'han.json:json-error)))))

(cond (cl-user::*han-probe-listener-files*
       (apply #'run-probe cl-user::*han-probe-listener-files*))
      ((and (uiop:getenv "HAN_PROBE_CASES") (uiop:getenv "HAN_PROBE_RESULTS"))
       (handler-case
           (progn
             (run-probe (uiop:getenv "HAN_PROBE_CASES") (uiop:getenv "HAN_PROBE_RESULTS"))
             (uiop:quit 0))
         (error (c)
           (format *error-output* "~&Probe failed: ~A~%" c)
           (uiop:quit 1))))
      (t (error "Start check-host-boundaries.py --listener and load the file it prints.")))
