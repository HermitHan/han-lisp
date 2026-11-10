# `han.host:host-process-native-handle`

[English](host-process-native-handle.md)

*访问器*

## 语法

```text
(han.host:host-process-native-handle process) → backend-specific object or nil
```

## 说明

读取句柄保存的原生资源。ECL、CCL 与 SBCL 各自存储对应实现的进程对象，LispWorks 存储可查询退出状态的输出流。该访问器支持赋值，槽内容因实现而异。跨实现的等待与状态查询应使用对应的公开函数。

## 示例

读取示例进程句柄的 native-handle 槽中保存的值。

```lisp
(let ((handle (han.host:make-host-process :native-handle :example)))
  (han.host:host-process-native-handle handle))
;; => :EXAMPLE
```

查看实际运行的后端用哪种原生资源跟踪退出状态。

```lisp
(let ((child (han.host:run-program "/bin/sh" :arguments '("-c" "exit 0"))))
  (unwind-protect
       (progn
         (han.host:process-wait child)
         (let ((native (han.host:host-process-native-handle child)))
           (ecase (han.host:host-process-backend child)
             ((:sbcl :ecl :ccl) (not (null native)))
             (:lispworks (streamp native)))))
    (han.host:process-close child)))
;; => T
```

[`han.host:host-process-backend`](host-process-backend.zh-CN.md) · [`han.host:process-status`](process-status.zh-CN.md) · [common.lisp](../../../host/common.lisp) · [索引](../README.zh-CN.md)
