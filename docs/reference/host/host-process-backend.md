# `han.host:host-process-backend`

*Accessor · 访问器*

## Syntax · 语法

```text
(han.host:host-process-backend process) → backend tag
```

## Description · 说明

Reads the backend slot of a `host-process`. Live handles are tagged `:sbcl` or `:lispworks` by the active adapter. The slot can be set with `setf`. Changing it does not convert the underlying OS resource.

读取进程句柄的后端槽。实际启动的句柄会被标记为 `:sbcl` 或 `:lispworks`。访问器支持 `setf`，修改标签不会转换底层系统资源。

## Examples · 示例

Read the backend identifier supplied when creating a handle.

读取构造句柄时指定的后端标识。

```lisp
(han.host:host-process-backend (han.host:make-host-process :backend :sample))
;; => :SAMPLE
```

Check the adapter tag of a real child before entering backend-specific diagnostics.

在运行针对实现的诊断前，从实际子进程句柄确认后端标签。

```lisp
(let ((child (han.host:run-program "/bin/sh" :arguments '("-c" "exit 0"))))
  (unwind-protect
       (progn
         (han.host:process-wait child)
         (not (null (member (han.host:host-process-backend child) '(:sbcl :lispworks)))))
    (han.host:process-close child)))
;; => T
```

[`han.host:host-process`](host-process.md) · [`han.host:host-process-native-handle`](host-process-native-handle.md) · [common.lisp](../../../host/common.lisp) · [Index · 索引](../README.md)
