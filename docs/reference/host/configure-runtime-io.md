# `han.host:configure-runtime-io`

[简体中文](configure-runtime-io.zh-CN.md)

*Function*

## Syntax

```text
(han.host:configure-runtime-io) → t
```

## Description

Configures a CLI's live streams. LispWorks selects Unicode/UTF-8, binds standard output to descriptor 1, and directs both error and trace output to descriptor 2. On SBCL, ECL and CCL it returns `t` and preserves the existing streams. The examples configure a child so that the parent keeps its interactive streams.

## Examples

Prepare and configure I/O in a fresh Lisp process and check its exit code.

```lisp
(nth-value 2
  (han.host:run-program-sync
   (list #+(or ecl ccl) (first (han.host:argv t)) #-(or ecl ccl) (han.host:find-executable "sbcl")
         #+ecl "--norc" #+ccl "--no-init" #-(or ecl ccl) "--no-userinit"
         #+ecl "--nodebug" #+ccl "--batch" #-(or ecl ccl) "--non-interactive"
         "--load" (namestring (asdf:system-relative-pathname "han" "load-han.lisp"))
         "--eval" "(progn (han.host:prepare-runtime-io) (assert (han.host:configure-runtime-io)))"
         "--eval" "(han.host:quit)")))
;; => 0
```

Write U+8BFB (读) to the child’s stderr, redirect it to a fresh file and read it as UTF-8. The ASCII evaluator expression and explicit file encoding keep the check independent of the launcher’s argument decoding and the parent’s default text encoding.

```lisp
(let ((root (uiop:ensure-directory-pathname
             (uiop:run-program '("mktemp" "-d") :output :line))))
  (unwind-protect
       (let* ((file (merge-pathnames "diagnostic" root))
              (code (nth-value 2
                      (han.host:run-program-sync
                       (list #+(or ecl ccl) (first (han.host:argv t))
                             #-(or ecl ccl) (han.host:find-executable "sbcl")
                             #+ecl "--norc" #+ccl "--no-init" #-(or ecl ccl) "--no-userinit"
                             #+ecl "--nodebug" #+ccl "--batch" #-(or ecl ccl) "--non-interactive"
                             "--load" (namestring (asdf:system-relative-pathname "han" "load-han.lisp"))
                             "--eval" "(progn (han.host:configure-runtime-io) (format *error-output* \"~&han-probe=~C~%\" (code-char #x8BFB)) (finish-output *error-output*))"
                             "--eval" "(han.host:quit)")
                       :error-output file))))
         (list code (not (null (member "han-probe=读" (han.os:load-lines file)
                                       :test #'string=)))))
    (uiop:delete-directory-tree root :validate t :if-does-not-exist :ignore)))
;; => (0 T)
```

[`han.host:prepare-runtime-io`](prepare-runtime-io.md) · [`han.host:standard-error-terminal-p`](standard-error-terminal-p.md) · [sbcl.lisp](../../../host/sbcl.lisp) · [lispworks.lisp](../../../host/lispworks.lisp) · [ecl.lisp](../../../host/ecl.lisp) · [ccl.lisp](../../../host/ccl.lisp) · [unsupported.lisp](../../../host/unsupported.lisp) · [Index](../README.md)
