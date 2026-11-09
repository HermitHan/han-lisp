# `han.host:process-close`

[简体中文](process-close.zh-CN.md)

*Function*

## Syntax

```text
(han.host:process-close process) → nil
```

## Description

Releases the local process streams and backend resources, returning `nil`. It does not request that the child be terminated. Wrap handle use in `unwind-protect` so resources are released if reading or processing output fails.

## Examples

Wait for a child and close its handle, then check whether its output stream is still open.

```lisp
(let ((child (han.host:run-program "/bin/sh" :arguments '("-c" "exit 0"))))
  (unwind-protect
       (han.host:process-wait child)
    (han.host:process-close child))
  (open-stream-p (han.host:host-process-output-stream child)))
;; => NIL
```

Release the handle when parsing fails and translate a malformed response into a result the caller can handle.

```lisp
(let ((child (han.host:run-program "/bin/sh" :arguments '("-c" "printf invalid"))))
  (handler-case
      (unwind-protect
           (progn (han.host:process-wait child)
                  (parse-integer (read-line (han.host:host-process-output-stream child))))
        (han.host:process-close child))
    (parse-error () :invalid-number)))
;; => :INVALID-NUMBER
```

[`han.host:process-wait`](process-wait.md) · [`han.host:host-process-output-stream`](host-process-output-stream.md) · [sbcl.lisp](../../../host/sbcl.lisp) · [lispworks.lisp](../../../host/lispworks.lisp) · [ecl.lisp](../../../host/ecl.lisp) · [Index](../README.md)
