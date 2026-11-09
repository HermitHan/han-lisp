# `han.host:process-wait`

[简体中文](process-wait.zh-CN.md)

*Function*

## Syntax

```text
(han.host:process-wait process) → the same host-process
```

## Description

Blocks until the child exits and returns the original process handle. Read its exit code separately afterwards. A child that fills either pipe can block before exiting, so drain large stdout and stderr while it runs or choose synchronous capture.

## Examples

Wait for a child to finish and check that the returned object is the original handle.

```lisp
(let ((child (han.host:run-program "/bin/sh" :arguments '("-c" "exit 0"))))
  (unwind-protect
       (eq child (han.host:process-wait child))
    (han.host:process-close child)))
;; => T
```

Collect a child after reading its output to EOF, then interpret the exit code.

```lisp
(let ((child (han.host:run-program "/bin/sh" :arguments '("-c" "printf scanned; exit 6"))))
  (unwind-protect
       (let ((result (han.os:load-string (han.host:host-process-output-stream child))))
         (han.host:process-wait child)
         (list result (han.host:process-exit-code child)))
    (han.host:process-close child)))
;; => ("scanned" 6)
```

[`han.host:process-exit-code`](process-exit-code.md) · [`han.host:process-close`](process-close.md) · [sbcl.lisp](../../../host/sbcl.lisp) · [lispworks.lisp](../../../host/lispworks.lisp) · [ecl.lisp](../../../host/ecl.lisp) · [Index](../README.md)
