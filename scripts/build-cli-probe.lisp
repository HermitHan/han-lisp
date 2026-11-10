;; Build a real, minimal Han executable. The Python driver selects a fresh
;; working directory, sets HAN_CLI_ROOT, and invokes the implementation.
(require :asdf)
#+ecl (require :cmp)
(asdf:load-asd (truename (merge-pathnames "han.asd" (uiop:getenv "HAN_CLI_ROOT"))))
(asdf:load-system :han)

(defparameter *cli-fixture*
  (merge-pathnames "probe-cli-boundaries.lisp" *load-truename*))
#-ecl (load *cli-fixture*)

#+sbcl
(sb-ext:save-lisp-and-die "probe" :toplevel #'cli-probe-main :executable t)
#+ccl
(ccl:save-application "probe" :toplevel-function #'cli-probe-main
                      :init-file nil :prepend-kernel t)
#+lispworks
(progn (compile 'cli-probe-main) (lw:deliver 'cli-probe-main "probe" 5))
#+ecl
(progn
  (asdf:operate 'asdf:monolithic-lib-op :han)
  (multiple-value-bind (object warnings failure)
      (compile-file *cli-fixture* :output-file "probe.o" :system-p t)
    (declare (ignore warnings))
    (assert (not failure))
    (c:build-program "probe"
                     :lisp-files (append (asdf:output-files 'asdf:monolithic-lib-op :han)
                                         (list object))
                     :epilogue-code '(cli-probe-main)))
  (ext:quit 0))
