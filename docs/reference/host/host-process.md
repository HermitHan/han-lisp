# `han.host:host-process`

*Structure type · 结构体类型*

## Syntax · 语法

```text
han.host:host-process → structure type
```

## Description · 说明

Represents an asynchronously launched child. The structure holds backend identity, native resource, PID, I/O slots and status bookkeeping. Obtain a live instance from `run-program` and use `process-close` to release it. A manually constructed instance can hold metadata without any OS resource.

表示异步启动的子进程。结构保存宿主标识、原生资源、PID、I/O 槽和状态记录。用 `run-program` 取得活动句柄，最后用 `process-close` 释放。手工构造的实例也可以只保存元数据，不持有系统资源。

## Examples · 示例

Check the type of a newly constructed process handle.

检查新构造的进程句柄的类型。

```lisp
(typep (han.host:make-host-process) 'han.host:host-process)
;; => T
```

Dispatch a real asynchronous result by type before accessing its exit status.

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

[`han.host:run-program`](run-program.md) · [`han.host:make-host-process`](make-host-process.md) · [`han.host:process-close`](process-close.md) · [common.lisp](../../../host/common.lisp) · [Index · 索引](../README.md)
