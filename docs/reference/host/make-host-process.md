# `han.host:make-host-process`

[简体中文](make-host-process.zh-CN.md)

*Structure constructor*

## Syntax

```text
(han.host:make-host-process &key backend native-handle pid input-stream output-stream error-stream exit-code signal-code) → host-process
```

## Description

Allocates a structure and initializes the named slots, each defaulting to `nil`. It does not start a process. It is useful for representing handles in adapter code. The live process operations need the native resources supplied by the active backend.

## Examples

Construct a handle and read back its backend identifier and PID.

```lisp
(let ((handle (han.host:make-host-process :backend :example :pid 17)))
  (list (han.host:host-process-backend handle)
        (han.host:host-process-pid handle)))
;; => (:EXAMPLE 17)
```

Construct a stream-backed fixture for a function that normally reads a live child's stdout.

```lisp
(with-input-from-string (messages (format nil "prepared~%complete~%"))
  (let ((fixture (han.host:make-host-process :output-stream messages)))
    (han.os:load-lines (han.host:host-process-output-stream fixture))))
;; => ("prepared" "complete")
```

[`han.host:host-process`](host-process.md) · [`han.host:run-program`](run-program.md) · [common.lisp](../../../host/common.lisp) · [Index](../README.md)
