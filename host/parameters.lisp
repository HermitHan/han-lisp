(in-package :han.host)

(defparameter *supported-implementations*
  '("SBCL" "LispWorks" "ECL"))

(defun supported-implementations-string ()
  (format nil "~{~A~^, ~}" *supported-implementations*))
