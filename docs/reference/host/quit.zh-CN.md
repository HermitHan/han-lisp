# `han.host:quit`

[English](quit.md)

*函数*

## 语法

```text
(han.host:quit &optional (code 0)) → does not return
```

## 说明

先刷新 `*standard-output*` 和 `*error-output*`，再结束当前 Lisp 进程。若刷新标准输出时报错，请求的退出码 0 改为 1，显式请求的非零退出码按原值返回。最后一次刷新标准错误只尽力写出，应用已处理的可选进度提示写入失败不会让已完成的命令误报失败。若某条标准错误输出必须送达，在请求成功退出前对该流调用 `finish-output`。在 Han 的命令行错误处理范围内，刷新标准输出失败导致退出码改变时，会在可写的标准错误上报告原因。CCL 正常退出时，原生输出流末行若已有文本但没有换行，运行时会补一个换行。示例在子进程中加载本仓库并退出，父进程读取退出码后可以继续使用。在 ECL 和 CCL 上，子进程采用当前内核；在其他宿主上使用 `sbcl` 命令。

## 示例

让 Lisp 子进程以退出码 7 结束，再从父进程读取该退出码。

```lisp
(nth-value 2
  (han.host:run-program-sync
   (list #+(or ecl ccl) (first (han.host:argv t)) #-(or ecl ccl) (han.host:find-executable "sbcl")
         #+ecl "--norc" #+ccl "--no-init" #-(or ecl ccl) "--no-userinit"
         #+ecl "--nodebug" #+ccl "--batch" #-(or ecl ccl) "--non-interactive"
         "--load" (namestring (asdf:system-relative-pathname "han" "load-han.lisp"))
         "--eval" "(han.host:quit 7)")))
;; => 7
```

输出结果并刷新后，以默认成功状态退出。退出发生在 Lisp 子进程中。

```lisp
(multiple-value-bind (stdout stderr code)
    (han.host:run-program-sync
     (list #+(or ecl ccl) (first (han.host:argv t)) #-(or ecl ccl) (han.host:find-executable "sbcl")
           #+ecl "--norc" #+ccl "--no-init" #-(or ecl ccl) "--no-userinit"
           #+ecl "--nodebug" #+ccl "--batch" #-(or ecl ccl) "--non-interactive"
           "--load" (namestring (asdf:system-relative-pathname "han" "load-han.lisp"))
           "--eval" "(progn (write-line \"READY\" *error-output*) (finish-output *error-output*) (han.host:quit))"))
  (declare (ignore stdout))
  (list code (not (null (search "READY" stderr)))))
;; => (0 T)
```

[`han.host:run-program-sync`](run-program-sync.zh-CN.md) · [`han.host:process-exit-code`](process-exit-code.zh-CN.md) · [sbcl.lisp](../../../host/sbcl.lisp) · [lispworks.lisp](../../../host/lispworks.lisp) · [ecl.lisp](../../../host/ecl.lisp) · [ccl.lisp](../../../host/ccl.lisp) · [unsupported.lisp](../../../host/unsupported.lisp) · [索引](../README.zh-CN.md)
