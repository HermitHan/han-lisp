# `han.host:process-exit-code`

[English](process-exit-code.md)

*函数*

## 语法

```text
(han.host:process-exit-code process) → integer or nil
```

## 说明

已有退出状态时返回整数，当前不可用时返回 `nil`。要取得已结束子进程的结果，可以先调用 `process-wait`。三个适配器都原样返回正常退出码，包括零。在 Unix 上，子进程被信号终止时，SBCL 返回信号编号，LispWorks 和 ECL 返回 128 加信号编号。例如，SIGTERM 在 SBCL 上对应 15，在 LispWorks 和 ECL 上对应 143。正常退出也可以使用相同的整数。

## 示例

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

[`han.host:process-wait`](process-wait.zh-CN.md) · [`han.host:run-program-sync`](run-program-sync.zh-CN.md) · [sbcl.lisp](../../../host/sbcl.lisp) · [lispworks.lisp](../../../host/lispworks.lisp) · [ecl.lisp](../../../host/ecl.lisp) · [索引](../README.zh-CN.md)
