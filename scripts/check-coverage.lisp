;;;; sbcl --script scripts/check-coverage.lisp /path/to/report/
(require :asdf)
(require :sb-cover)

(defparameter *report-directory*
  (let ((arguments (uiop:command-line-arguments)))
    (unless (= (length arguments) 1)
      (error "Usage: sbcl --script scripts/check-coverage.lisp REPORT-DIRECTORY"))
    (uiop:ensure-directory-pathname (first arguments))))

(defparameter *checkout*
  (uiop:pathname-parent-directory-pathname
   (uiop:pathname-directory-pathname *load-truename*)))

(defun runtime-source-files (component)
  (typecase component
    (asdf:cl-source-file (list (namestring (truename (asdf:component-pathname component)))))
    (asdf:module (mapcan #'runtime-source-files (asdf:component-children component)))))

(asdf:load-asd (merge-pathnames "han.asd" *checkout*))
(asdf:load-asd (merge-pathnames "han.dev.asd" *checkout*))
(defparameter *runtime-files* (runtime-source-files (asdf:find-system "han")))

(declaim (optimize sb-cover:store-coverage-data))
(asdf:load-system "han.dev" :force t)
(sb-cover:reset-coverage)
(multiple-value-bind (passed failed) (han.test:run-all-tests)
  (sb-cover:report *report-directory*
                   :if-matches (lambda (file) (member file *runtime-files* :test #'string=)))
  (uiop:quit (if (and (plusp passed) (zerop failed)) 0 1)))
