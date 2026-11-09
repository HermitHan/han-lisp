# `han.host:run-program-sync`

[English](run-program-sync.md)

*函数*

## 语法

```text
(han.host:run-program-sync command &key input (output :string) (error-output :string) (ignore-error-status t)) → stdout, stderr, exit-code
```

## 说明

等待命令结束并返回三个值。字符串列表直接传 argv，命令字符串按 shell 语法执行。默认输入为 EOF，`t` 表示标准输入，字符流提供其剩余内容。输出选项 `:string` 捕获文本；`t` 或输出流会在结束后重放文本，对应返回值为 `nil`。捕获使用临时文件。

正常退出时返回程序自己的退出码。子进程被 Unix 信号终止时，SBCL 返回信号编号，LispWorks 和 ECL 返回 128 加信号编号。将 `ignore-error-status` 设为 `nil`，这两种情况下的非零状态都会触发错误。直接传 argv 时，如果程序文件不存在或缺少执行权限，即使用默认的 `ignore-error-status t` 也会在启动时触发错误。

传入 `:input t` 时，SBCL 把当前标准输入流交给后端。LispWorks 和 ECL 会先读到 EOF，将输入写入临时文件，再启动子进程。捕获和重放标准输出、标准错误时，按宿主默认外部编码将临时文件读为文本。

直接传 argv 时，第一个字符串应使用可执行文件的完整路径。各后端查找裸程序名的行为有差异。按名称查找工具时，先调用 [`find-executable`](find-executable.zh-CN.md) 并检查结果是否为 `nil`。

在 ECL 的同步调用中，给 `input`、`output` 或 `error-output` 传 `:stream` 会在启动前发出 `simple-error`。同步输出可用 `:string` 捕获，传已有输出流或 `t` 重放，也可传文件路径重定向。需要实时管道时请用 [run-program](run-program.zh-CN.md) 启动子进程。

## 示例

运行一条 shell 命令，同时取得标准输出、标准错误和退出码。

```lisp
(multiple-value-list
 (han.host:run-program-sync
  '("/bin/sh" "-c" "printf out; printf err >&2; exit 3")))
;; => ("out" "err" 3)
```

把字符流作为工作进程的输入，将其输出重放到调用方的缓冲区。

```lisp
(with-input-from-string (input "rows")
  (let ((sink (make-string-output-stream)))
    (multiple-value-bind (stdout stderr code)
        (han.host:run-program-sync '("/bin/cat") :input input :output sink)
      (list stdout stderr code (get-output-stream-string sink)))))
;; => (NIL "" 0 "rows")
```

调用方需要作业失败立即中断时，将非零退出码转换为 Lisp 错误。

```lisp
(han.host:run-program-sync '("/bin/sh" "-c" "exit 9") :ignore-error-status nil)
;; signals simple-error
```

[`han.host:run-program`](run-program.zh-CN.md) · [`han.os:run-program`](../os/run-program.zh-CN.md) · [sbcl.lisp](../../../host/sbcl.lisp) · [lispworks.lisp](../../../host/lispworks.lisp) · [ecl.lisp](../../../host/ecl.lisp) · [索引](../README.zh-CN.md)
