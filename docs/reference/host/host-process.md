# `han.host:host-process`

[简体中文](host-process.zh-CN.md)

*Structure type*

## Syntax

```text
han.host:host-process → structure type
```

## Description

Represents an asynchronously launched child. The structure holds backend identity, native resource, PID, I/O slots and status bookkeeping. Obtain a live instance from `run-program` and use `process-close` to release it. A manually constructed instance can hold metadata without any OS resource.

## Examples

Check the type of a newly constructed process handle.

```lisp
(typep (han.host:make-host-process) 'han.host:host-process)
;; => T
```

Dispatch a real asynchronous result by type before accessing its exit status.

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

[`han.host:run-program`](run-program.md) · [`han.host:make-host-process`](make-host-process.md) · [`han.host:process-close`](process-close.md) · [common.lisp](../../../host/common.lisp) · [Index](../README.md)
