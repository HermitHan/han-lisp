# `han.host:host-process-native-handle`

[简体中文](host-process-native-handle.zh-CN.md)

*Accessor*

## Syntax

```text
(han.host:host-process-native-handle process) → backend-specific object or nil
```

## Description

Reads the native resource slot of a `host-process`. ECL and SBCL store their respective process objects. LispWorks stores the status-bearing output stream. This settable accessor exposes implementation-specific data. Use the public wait/status functions when the same code must run on multiple backends.

## Examples

Retrieve the value stored in the native-handle slot of a sample process handle.

```lisp
(let ((handle (han.host:make-host-process :native-handle :example)))
  (han.host:host-process-native-handle handle))
;; => :EXAMPLE
```

Use the live native resource to check how the active adapter tracks exit status.

```lisp
(let ((child (han.host:run-program "/bin/sh" :arguments '("-c" "exit 0"))))
  (unwind-protect
       (progn
         (han.host:process-wait child)
         (let ((native (han.host:host-process-native-handle child)))
           (ecase (han.host:host-process-backend child)
             ((:sbcl :ecl) (not (null native)))
             (:lispworks (streamp native)))))
    (han.host:process-close child)))
;; => T
```

[`han.host:host-process-backend`](host-process-backend.md) · [`han.host:process-status`](process-status.md) · [common.lisp](../../../host/common.lisp) · [Index](../README.md)
