# `han.host:quit`

[简体中文](quit.zh-CN.md)

*Function*

## Syntax

```text
(han.host:quit &optional (code 0)) → does not return
```

## Description

Flushes `*standard-output*` and `*error-output*`, then terminates the running Lisp process. If the standard output flush signals an error, a requested status of 0 becomes 1. An explicitly requested nonzero status is preserved. The final stderr flush is best effort, so a progress message that the caller already handled as optional cannot turn a completed command into a failure. If delivery on stderr is required, call `finish-output` there before requesting success. Inside Han’s executable error boundary, a failed stdout flush that changes the status is reported on stderr when it is writable. CCL’s normal shutdown adds a newline to a partial final line on its native output streams. The examples run this checkout in a child, using the running kernel on ECL and CCL and the `sbcl` command on other hosts. The parent REPL stays open.

## Examples

Exit a child Lisp process with code 7 and read the code in its parent.

```lisp
(nth-value 2
  (han.host:run-program-sync
   (list #+(or ecl ccl) (first (han.host:argv t)) #-(or ecl ccl) (han.host:find-executable "sbcl")
         #+ecl "--norc" #+ccl "--no-init" #-(or ecl ccl) "--no-userinit"
         #+ecl "--nodebug" #+ccl "--batch" #-(or ecl ccl) "--non-interactive"
         "--load" (namestring (asdf:system-relative-pathname "han" "load-han.lisp"))
         "--eval" "(han.host:quit 7)")))
;; => 7
```

Use the default success exit after flushing a result. Only the child Lisp image exits.

```lisp
(multiple-value-bind (stdout stderr code)
    (han.host:run-program-sync
     (list #+(or ecl ccl) (first (han.host:argv t)) #-(or ecl ccl) (han.host:find-executable "sbcl")
           #+ecl "--norc" #+ccl "--no-init" #-(or ecl ccl) "--no-userinit"
           #+ecl "--nodebug" #+ccl "--batch" #-(or ecl ccl) "--non-interactive"
           "--load" (namestring (asdf:system-relative-pathname "han" "load-han.lisp"))
           "--eval" "(progn (write-line \"READY\" *error-output*) (finish-output *error-output*) (han.host:quit))"))
  (declare (ignore stdout))
  (list code (not (null (search "READY" stderr)))))
;; => (0 T)
```

[`han.host:run-program-sync`](run-program-sync.md) · [`han.host:process-exit-code`](process-exit-code.md) · [sbcl.lisp](../../../host/sbcl.lisp) · [lispworks.lisp](../../../host/lispworks.lisp) · [ecl.lisp](../../../host/ecl.lisp) · [ccl.lisp](../../../host/ccl.lisp) · [unsupported.lisp](../../../host/unsupported.lisp) · [Index](../README.md)
