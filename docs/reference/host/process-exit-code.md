# `han.host:process-exit-code`

*Function · 函数*

## Syntax · 语法

```text
(han.host:process-exit-code process) → integer or nil
```

## Description · 说明

Returns the exit status when it is available, otherwise `nil`. Inspect it after `process-wait` for a completed child. Both backends preserve ordinary exit codes, including zero. On Unix, when a signal terminates the child, SBCL returns the signal number and LispWorks returns 128 plus that number. For example, SIGTERM gives 15 on SBCL and 143 on LispWorks. An ordinary exit can use the same integer.

已有退出状态时返回整数，当前不可用时返回 `nil`。要取得已结束子进程的结果，可以先调用 `process-wait`。两个后端都原样返回正常退出码，包括零。在 Unix 上，子进程被信号终止时，SBCL 返回信号编号，LispWorks 返回 128 加信号编号。例如，SIGTERM 在 SBCL 上对应 15，在 LispWorks 上对应 143。正常退出也可以使用相同的整数。

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
