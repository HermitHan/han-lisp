# `han.host:host-process`

[English](host-process.md)

*结构体类型*

## 语法

```text
han.host:host-process → structure type
```

## 说明

表示异步启动的子进程。结构保存宿主标识、原生资源、PID、I/O 槽和状态记录。用 `run-program` 取得活动句柄，最后用 `process-close` 释放。手工构造的实例也可以只保存元数据，不持有系统资源。

## 示例

检查新构造的进程句柄的类型。

```lisp
(typep (han.host:make-host-process) 'han.host:host-process)
;; => T
```

根据异步操作实际返回的句柄类型分派，再读取其退出码。

```lisp
(let ((child (han.host:run-program "/bin/sh" :arguments '("-c" "exit 2"))))
  (unwind-protect
       (etypecase child
         (han.host:host-process
          (han.host:process-wait child)
          (han.host:process-exit-code child)))
    (han.host:process-close child)))
;; => 2
```

[`han.host:run-program`](run-program.zh-CN.md) · [`han.host:make-host-process`](make-host-process.zh-CN.md) · [`han.host:process-close`](process-close.zh-CN.md) · [common.lisp](../../../host/common.lisp) · [索引](../README.zh-CN.md)
