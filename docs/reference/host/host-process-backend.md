# `han.host:host-process-backend`

[简体中文](host-process-backend.zh-CN.md)

*Accessor*

## Syntax

```text
(han.host:host-process-backend process) → backend tag
```

## Description

Reads the backend slot of a `host-process`. Live handles are tagged `:sbcl`, `:lispworks`, `:ecl` or `:ccl` by the active adapter. The slot can be set with `setf`. Changing it does not convert the underlying OS resource.

## Examples

Read the backend identifier supplied when creating a handle.

```lisp
(han.host:host-process-backend (han.host:make-host-process :backend :sample))
;; => :SAMPLE
```

Check the adapter tag of a real child before entering backend-specific diagnostics.

```lisp
(let ((child (han.host:run-program "/bin/sh" :arguments '("-c" "exit 0"))))
  (unwind-protect
       (progn
         (han.host:process-wait child)
         (not (null (member (han.host:host-process-backend child) '(:sbcl :lispworks :ecl :ccl)))))
    (han.host:process-close child)))
;; => T
```

[`han.host:host-process`](host-process.md) · [`han.host:host-process-native-handle`](host-process-native-handle.md) · [common.lisp](../../../host/common.lisp) · [Index](../README.md)
