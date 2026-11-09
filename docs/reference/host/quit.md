# `han.host:quit`

[简体中文](quit.zh-CN.md)

*Function*

## Syntax

```text
(han.host:quit &optional (code 0)) → does not return
```

## Description

Terminates the running Lisp process with the requested exit status. LispWorks and ECL flush standard and error output before exit. The examples run this checkout in a child, using the current ECL executable on ECL and the `sbcl` command on other hosts. The parent REPL stays open.

## Examples

Exit a child Lisp process with code 7 and read the code in its parent.

```lisp
(nth-value 2
  (han.host:run-program-sync
   (list #+ecl (first (han.host:argv t)) #-ecl (han.host:find-executable "sbcl")
         #+ecl "--norc" #-ecl "--no-userinit"
         #+ecl "--nodebug" #-ecl "--non-interactive"
         "--load" (namestring (asdf:system-relative-pathname "han" "load-han.lisp"))
         "--eval" "(han.host:quit 7)")))
;; => 7
```

Use the default success exit after flushing a result. Only the child Lisp image exits.

```lisp
(multiple-value-bind (stdout stderr code)
    (han.host:run-program-sync
     (list #+ecl (first (han.host:argv t)) #-ecl (han.host:find-executable "sbcl")
           #+ecl "--norc" #-ecl "--no-userinit"
           #+ecl "--nodebug" #-ecl "--non-interactive"
           "--load" (namestring (asdf:system-relative-pathname "han" "load-han.lisp"))
           "--eval" "(progn (write-line \"READY\" *error-output*) (finish-output *error-output*) (han.host:quit))"))
  (declare (ignore stdout))
  (list code (not (null (search "READY" stderr)))))
;; => (0 T)
```

[`han.host:run-program-sync`](run-program-sync.md) · [`han.host:process-exit-code`](process-exit-code.md) · [sbcl.lisp](../../../host/sbcl.lisp) · [lispworks.lisp](../../../host/lispworks.lisp) · [ecl.lisp](../../../host/ecl.lisp) · [unsupported.lisp](../../../host/unsupported.lisp) · [Index](../README.md)
