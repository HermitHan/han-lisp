# `han.host:standard-error-terminal-p`

[简体中文](standard-error-terminal-p.zh-CN.md)

*Function*

## Syntax

```text
(han.host:standard-error-terminal-p) → boolean
```

## Description

Returns true when OS file descriptor 2 is attached to a terminal. A redirected or closed descriptor yields `nil`. The query ignores a rebound `*error-output*` and performs no stream reads or writes.

## Examples

Check that rebinding the Lisp error stream leaves the terminal check unchanged.

```lisp
(let ((before (han.host:standard-error-terminal-p))
      (*error-output* (make-string-output-stream)))
  (eql before (han.host:standard-error-terminal-p)))
;; => T
```

Choose plain diagnostics when the child's stderr is captured by the parent.

```lisp
(nth-value 2
  (han.host:run-program-sync
   (list #+(or ecl ccl) (first (han.host:argv t)) #-(or ecl ccl) (han.host:find-executable "sbcl")
         #+ecl "--norc" #+ccl "--no-init" #-(or ecl ccl) "--no-userinit"
         #+ecl "--nodebug" #+ccl "--batch" #-(or ecl ccl) "--non-interactive"
         "--load" (namestring (asdf:system-relative-pathname "han" "load-han.lisp"))
         "--eval" "(han.host:quit (if (han.host:standard-error-terminal-p) 1 0))" "--eval" "(han.host:quit)")))
;; => 0
```

[`han.host:standard-input-terminal-p`](standard-input-terminal-p.md) · [`han.host:configure-runtime-io`](configure-runtime-io.md) · [sbcl.lisp](../../../host/sbcl.lisp) · [lispworks.lisp](../../../host/lispworks.lisp) · [ecl.lisp](../../../host/ecl.lisp) · [ccl.lisp](../../../host/ccl.lisp) · [unsupported.lisp](../../../host/unsupported.lisp) · [Index](../README.md)
