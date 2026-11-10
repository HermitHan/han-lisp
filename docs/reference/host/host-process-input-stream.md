# `han.host:host-process-input-stream`

[简体中文](host-process-input-stream.zh-CN.md)

*Accessor*

## Syntax

```text
(han.host:host-process-input-stream process) → input slot value or nil
```

## Description

Reads the settable input slot. SBCL records the native process's input stream when available. On ECL and CCL, `:input :stream` supplies a writable pipe to the child. For other input designators this slot is `nil`. LispWorks stores the supplied `input` argument, so a handle may contain an input designator or `nil`. Check the value before treating it as a stream.

## Examples

Attach a string input stream to a handle and read one character through the accessor.

```lisp
(with-input-from-string (input "x")
  (let ((handle (han.host:make-host-process :input-stream input)))
    (read-char (han.host:host-process-input-stream handle))))
;; => #\x
```

Close a writable input slot to signal end-of-input. This example exercises a pipe-like stream fixture independently of backend conventions.

```lisp
(let* ((input (make-string-output-stream))
       (handle (han.host:make-host-process :input-stream input))
       (port (han.host:host-process-input-stream handle)))
  (when (and (streamp port) (output-stream-p port))
    (write-line "done" port)
    (finish-output port)
    (close port))
  (open-stream-p input))
;; => NIL
```

[`han.host:run-program`](run-program.md) · [`han.host:host-process-output-stream`](host-process-output-stream.md) · [common.lisp](../../../host/common.lisp) · [Index](../README.md)
