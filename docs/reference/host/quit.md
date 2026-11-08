# `han.host:quit`

*Function · 函数*

## Syntax · 语法

```text
(han.host:quit &optional (code 0)) → does not return
```

## Description · 说明

Terminates the running Lisp process with the requested exit status. LispWorks first tries to flush standard and error output. This example starts an SBCL child (the `sbcl` command must be available), loads this checkout there, and observes the child's exit code. The parent REPL stays open.

按给定退出码结束当前 Lisp 进程，LispWorks 会先尝试刷新标准输出和标准错误。示例需要可用的 `sbcl` 命令，在子进程里装载当前库并退出，再由父进程读取退出码，当前 REPL 可以继续使用。

## Examples · 示例

Exit a child Lisp process with code 7 and read the code in its parent.

让 Lisp 子进程以退出码 7 结束，再从父进程读取该退出码。

```lisp
(nth-value 2
  (han.host:run-program-sync
   (list "sbcl" "--noinform" "--no-sysinit" "--no-userinit" "--disable-debugger"
         "--load" (namestring (asdf:system-relative-pathname "han" "load-han.lisp"))
         "--eval" "(han.host:quit 7)")))
;; => 7
```

Use the default success exit after flushing a result. Only the child SBCL image exits.

输出结果并刷新后，以默认成功状态退出。退出发生在 SBCL 子进程中。

```lisp
(multiple-value-bind (stdout stderr code)
    (han.host:run-program-sync
     (list "sbcl" "--noinform" "--no-sysinit" "--no-userinit" "--disable-debugger"
           "--load" (namestring (asdf:system-relative-pathname "han" "load-han.lisp"))
           "--eval" "(progn (write-line \"READY\" *error-output*) (finish-output *error-output*) (han.host:quit))"))
  (declare (ignore stdout))
  (list code (not (null (search "READY" stderr)))))
;; => (0 T)
```

[`han.host:run-program-sync`](run-program-sync.md) · [`han.host:process-exit-code`](process-exit-code.md) · [sbcl.lisp](../../../host/sbcl.lisp) · [lispworks.lisp](../../../host/lispworks.lisp) · [unsupported.lisp](../../../host/unsupported.lisp) · [Index · 索引](../README.md)
