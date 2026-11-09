# `han.host:host-process-pid`

[简体中文](host-process-pid.zh-CN.md)

*Accessor*

## Syntax

```text
(han.host:host-process-pid process) → child PID or nil
```

## Description

Reads the `pid` slot of a `host-process`. A live adapter fills it with the child's process identifier when available. The generated accessor supports `setf`. A structure created without a PID returns `nil`.

## Examples

Read the process ID stored in a manually constructed handle.

```lisp
(let ((handle (han.host:make-host-process :pid 23)))
  (han.host:host-process-pid handle))
;; => 23
```

Match a shell's self-reported process ID to the child handle.

```lisp
(let ((child (han.host:run-program "/bin/sh" :arguments '("-c" "printf '%s' \"$$\""))))
  (unwind-protect
       (progn
         (han.host:process-wait child)
         (= (parse-integer (read-line (han.host:host-process-output-stream child)))
            (han.host:host-process-pid child)))
    (han.host:process-close child)))
;; => T
```

[`han.host:current-process-id`](current-process-id.md) · [`han.host:host-process`](host-process.md) · [common.lisp](../../../host/common.lisp) · [Index](../README.md)
