# `han.host:current-process-id`

*Function · 函数*

## Syntax · 语法

```text
(han.host:current-process-id) → positive integer
```

## Description · 说明

Returns the OS process ID of the currently running Lisp. The number is assigned by the operating system. To inspect a child, read the PID slot of the child's handle.

返回当前 Lisp 进程的操作系统 PID，是系统分配的正整数。需要子进程的 PID 时，从子进程句柄上读取。

## Examples · 示例

Check that the running Lisp process has a positive integer PID.

检查当前 Lisp 进程的 PID 是否为正整数。

```lisp
(let ((pid (han.host:current-process-id)))
  (and (integerp pid) (plusp pid)))
;; => T
```

Tag log records with the current PID and recognize records written by this process.

给日志记录标记 PID，读回时判断是否为当前进程所写。

```lisp
(uiop:with-temporary-file (:pathname log)
  (han.host:append-utf8-line log (write-to-string (han.host:current-process-id)))
  (= (parse-integer (first (han.os:load-lines log))) (han.host:current-process-id)))
;; => T
```

[`han.host:host-process-pid`](host-process-pid.md) · [`han.host:run-program`](run-program.md) · [sbcl.lisp](../../../host/sbcl.lisp) · [lispworks.lisp](../../../host/lispworks.lisp) · [unsupported.lisp](../../../host/unsupported.lisp) · [Index · 索引](../README.md)
