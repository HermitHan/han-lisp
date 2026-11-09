# `han.host:quit`

[English](quit.md)

*函数*

## 语法

```text
(han.host:quit &optional (code 0)) → does not return
```

## 说明

按给定退出码结束当前 Lisp 进程，LispWorks 和 ECL 会先刷新标准输出和标准错误。示例在子进程中加载本仓库并退出，父进程读取退出码后可以继续使用。在 ECL 上，子进程采用当前 ECL 可执行文件；在其他宿主上使用 `sbcl` 命令。

## 示例

让 Lisp 子进程以退出码 7 结束，再从父进程读取该退出码。

```lisp
(nth-value 2
  (han.host:run-program-sync
   (list #+ecl (first (han.host:argv t)) #-ecl (han.host:find-executable "sbcl")
         #+ecl "--norc" #-ecl "--no-userinit"
         #+ecl "--nodebug" #-ecl "--non-interactive"
         "--load" (namestring (asdf:system-relative-pathname "han" "load-han.lisp"))
         "--eval" "(han.host:quit 7)")))
;; => 7
```

输出结果并刷新后，以默认成功状态退出。退出发生在 Lisp 子进程中。

```lisp
(multiple-value-bind (stdout stderr code)
    (han.host:run-program-sync
     (list #+ecl (first (han.host:argv t)) #-ecl (han.host:find-executable "sbcl")
           #+ecl "--norc" #-ecl "--no-userinit"
           #+ecl "--nodebug" #-ecl "--non-interactive"
           "--load" (namestring (asdf:system-relative-pathname "han" "load-han.lisp"))
           "--eval" "(progn (write-line \"READY\" *error-output*) (finish-output *error-output*) (han.host:quit))"))
  (declare (ignore stdout))
  (list code (not (null (search "READY" stderr)))))
;; => (0 T)
```

[`han.host:run-program-sync`](run-program-sync.zh-CN.md) · [`han.host:process-exit-code`](process-exit-code.zh-CN.md) · [sbcl.lisp](../../../host/sbcl.lisp) · [lispworks.lisp](../../../host/lispworks.lisp) · [ecl.lisp](../../../host/ecl.lisp) · [unsupported.lisp](../../../host/unsupported.lisp) · [索引](../README.zh-CN.md)
