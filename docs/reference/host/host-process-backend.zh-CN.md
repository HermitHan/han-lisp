# `han.host:host-process-backend`

[English](host-process-backend.md)

*访问器*

## 语法

```text
(han.host:host-process-backend process) → backend tag
```

## 说明

读取进程句柄的后端槽。实际启动的句柄会被标记为 `:sbcl`、`:lispworks` 或 `:ecl`。访问器支持 `setf`，修改标签不会转换底层系统资源。

## 示例

读取构造句柄时指定的后端标识。

```lisp
(han.host:host-process-backend (han.host:make-host-process :backend :sample))
;; => :SAMPLE
```

在运行针对实现的诊断前，从实际子进程句柄确认后端标签。

```lisp
(let ((child (han.host:run-program "/bin/sh" :arguments '("-c" "exit 0"))))
  (unwind-protect
       (progn
         (han.host:process-wait child)
         (not (null (member (han.host:host-process-backend child) '(:sbcl :lispworks :ecl)))))
    (han.host:process-close child)))
;; => T
```

[`han.host:host-process`](host-process.zh-CN.md) · [`han.host:host-process-native-handle`](host-process-native-handle.zh-CN.md) · [common.lisp](../../../host/common.lisp) · [索引](../README.zh-CN.md)
