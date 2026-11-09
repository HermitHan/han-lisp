# `han.host:host-process-error-stream`

[简体中文](host-process-error-stream.zh-CN.md)

*Accessor*

## Syntax

```text
(han.host:host-process-error-stream process) → child stderr stream or nil
```

## Description

Reads the settable stderr slot. With `run-program` it is the separate pipe for the child's diagnostics. A newly constructed empty handle has no stream. If a child produces substantial output on both pipes, the caller must drain both or use synchronous capture.

## Examples

Read the message that a child shell writes to standard error.

```lisp
(let ((child (han.host:run-program "/bin/sh" :arguments '("-c" "printf detail >&2"))))
  (unwind-protect
       (progn
         (han.host:process-wait child)
         (read-line (han.host:host-process-error-stream child) nil))
    (han.host:process-close child)))
;; => "detail"
```

Keep human diagnostics separate from machine-readable stdout.

```lisp
(let ((child (han.host:run-program "/bin/sh" :arguments '("-c" "printf 12; printf warning >&2"))))
  (unwind-protect
       (progn
         (han.host:process-wait child)
         (list (parse-integer (read-line (han.host:host-process-output-stream child)))
               (read-line (han.host:host-process-error-stream child))))
    (han.host:process-close child)))
;; => (12 "warning")
```

[`han.host:host-process-output-stream`](host-process-output-stream.md) · [`han.host:run-program-sync`](run-program-sync.md) · [common.lisp](../../../host/common.lisp) · [Index](../README.md)
