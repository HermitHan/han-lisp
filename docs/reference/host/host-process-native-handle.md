# `han.host:host-process-native-handle`

*Accessor · 访问器*

## Syntax · 语法

```text
(han.host:host-process-native-handle process) → backend-specific object or nil
```

## Description · 说明

Reads the native resource slot of a `host-process`. SBCL stores its process object. LispWorks stores the status-bearing output stream. This settable accessor exposes implementation-specific data. Use the public wait/status functions when the same code must run on both backends.

读取句柄保存的原生资源。SBCL 存储进程对象，LispWorks 存储可查询退出状态的输出流。该访问器支持赋值，槽内容因实现而异。跨实现的等待与状态查询应使用对应的公开函数。

## Examples · 示例

Retrieve the value stored in the native-handle slot of a sample process handle.

读取示例进程句柄的 native-handle 槽中保存的值。

```lisp
(let ((handle (han.host:make-host-process :native-handle :example)))
  (han.host:host-process-native-handle handle))
;; => :EXAMPLE
```

Use the live native resource to check how the active adapter tracks exit status.

查看实际运行的后端用哪种原生资源跟踪退出状态。

```lisp
(let ((child (han.host:run-program "/bin/sh" :arguments '("-c" "exit 0"))))
  (unwind-protect
       (progn
         (han.host:process-wait child)
         (let ((native (han.host:host-process-native-handle child)))
           (ecase (han.host:host-process-backend child)
             (:sbcl (not (null native)))
             (:lispworks (streamp native)))))
    (han.host:process-close child)))
;; => T
```

[`han.host:host-process-backend`](host-process-backend.md) · [`han.host:process-status`](process-status.md) · [common.lisp](../../../host/common.lisp) · [Index · 索引](../README.md)
