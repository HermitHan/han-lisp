# `han.host:host-process-output-stream`

[简体中文](host-process-output-stream.zh-CN.md)

*Accessor*

## Syntax

```text
(han.host:host-process-output-stream process) → child stdout stream or nil
```

## Description

Reads the settable stdout slot. With `run-program` the parent reads the child's standard output from this pipe. A newly constructed empty handle has no stream. Consume large outputs while the child runs to keep its pipe from filling.

## Examples

Read the text written to standard output by a child shell.

```lisp
(let ((child (han.host:run-program "/bin/sh" :arguments '("-c" "printf stdout"))))
  (unwind-protect
       (progn
         (han.host:process-wait child)
         (read-line (han.host:host-process-output-stream child) nil))
    (han.host:process-close child)))
;; => "stdout"
```

Read several lines from stdout up to EOF before waiting for the child.

```lisp
(let ((child (han.host:run-program "/bin/sh" :arguments '("-c" "printf 'start\\nend\\n'"))))
  (unwind-protect
       (let ((lines (han.os:load-lines (han.host:host-process-output-stream child))))
         (han.host:process-wait child)
         lines)
    (han.host:process-close child)))
;; => ("start" "end")
```

[`han.host:host-process-error-stream`](host-process-error-stream.md) · [`han.host:process-close`](process-close.md) · [common.lisp](../../../host/common.lisp) · [Index](../README.md)
