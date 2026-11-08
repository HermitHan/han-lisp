# `han.host:process-exit-code`

*Function · 函数*

## Syntax · 语法

```text
(han.host:process-exit-code process) → integer or nil
```

## Description · 说明

Returns the exit status when it is available, otherwise `nil`. Inspect it after `process-wait` for a completed child. For an ordinary nonzero exit it returns that integer. LispWorks also translates a termination signal to 128 plus the signal number when only a signal was reported.

已有退出状态时返回整数，当前不可用时返回 `nil`。要得到已结束子进程的结果，可先调用 `process-wait`。正常退出但状态非零时返回该整数。LispWorks 在仅取得终止信号时会将其转换为 128 加信号编号。

## Examples · 示例

Wait for a child that exits with code 4, then read the code from its handle.

等待子进程以退出码 4 结束，再从句柄读取该退出码。

```lisp
(let ((child (han.host:run-program "/bin/sh" :arguments '("-c" "exit 4"))))
  (unwind-protect
       (progn
         (han.host:process-wait child)
         (han.host:process-exit-code child))
    (han.host:process-close child)))
;; => 4
```

Translate a worker's exit status into a caller-defined decision.

把工作进程的退出状态映射为上层程序的处理分支。

```lisp
(let ((child (han.host:run-program "/bin/sh" :arguments '("-c" "exit 2"))))
  (unwind-protect
       (progn
         (han.host:process-wait child)
         (case (han.host:process-exit-code child)
           (0 :ok)
           (2 :bad-input)
           (otherwise :failed)))
    (han.host:process-close child)))
;; => :BAD-INPUT
```

[`han.host:process-wait`](process-wait.md) · [`han.host:run-program-sync`](run-program-sync.md) · [sbcl.lisp](../../../host/sbcl.lisp) · [lispworks.lisp](../../../host/lispworks.lisp) · [Index · 索引](../README.md)
