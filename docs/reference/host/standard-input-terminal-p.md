# `han.host:standard-input-terminal-p`

[简体中文](standard-input-terminal-p.zh-CN.md)

*Function*

## Syntax

```text
(han.host:standard-input-terminal-p) → boolean
```

## Description

Tests whether OS file descriptor 0 is attached to a terminal. It does not consume input. Rebinding `*standard-input*` leaves the OS descriptor unchanged, which lets the example work in a terminal and under redirected input.

## Examples

Check that reading from a string leaves the terminal check unchanged.

```lisp
(let ((before (han.host:standard-input-terminal-p)))
  (with-input-from-string (*standard-input* "")
    (eql before (han.host:standard-input-terminal-p))))
;; => T
```

Detect batch input in a child Lisp process launched with redirected stdin.

```lisp
(nth-value 2
  (han.host:run-program-sync
   (list #+(or ecl ccl) (first (han.host:argv t)) #-(or ecl ccl) (han.host:find-executable "sbcl")
         #+ecl "--norc" #+ccl "--no-init" #-(or ecl ccl) "--no-userinit"
         #+ecl "--nodebug" #+ccl "--batch" #-(or ecl ccl) "--non-interactive"
         "--load" (namestring (asdf:system-relative-pathname "han" "load-han.lisp"))
         "--eval" "(han.host:quit (if (han.host:standard-input-terminal-p) 1 0))" "--eval" "(han.host:quit)")))
;; => 0
```

[`han.host:standard-error-terminal-p`](standard-error-terminal-p.md) · [`han.host:configure-runtime-io`](configure-runtime-io.md) · [sbcl.lisp](../../../host/sbcl.lisp) · [lispworks.lisp](../../../host/lispworks.lisp) · [ecl.lisp](../../../host/ecl.lisp) · [ccl.lisp](../../../host/ccl.lisp) · [unsupported.lisp](../../../host/unsupported.lisp) · [Index](../README.md)
