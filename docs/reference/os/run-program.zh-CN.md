# `han.os:run-program`

[English](run-program.md)

*函数*

## 语法

```text
(han.os:run-program command &key input (output :string) (error-output :string) (ignore-error-status t)) → stdout, stderr, exit-code
```

## 说明

通过 `han.host:run-program-sync` 同步执行。字符串列表表示 argv，命令字符串按 shell 语法解释。默认 stdin 读到 EOF，两路输出各自捕获为字符串。发送文本时可传入字符输入流。默认返回非零整数退出码，将 `ignore-error-status` 设为 `nil` 时则触发错误。指定输出流时会在运行完成后重放文本。

传入 `:input t` 时，LispWorks、ECL 和 CCL 会等到标准输入结束才启动子进程。CCL 按 UTF-8 解码捕获的输出，其他适配器沿用宿主默认外部编码。流的处理方式见[宿主函数](../host/run-program-sync.zh-CN.md)。

在 ECL 和 CCL 上，给同步输入输出的任一通道传 `:stream` 会在启动前发出 `simple-error`。要取得实时管道，使用 [han.host:run-program](../host/run-program.zh-CN.md)。

## 示例

把字符串传给 `cat`，并分别取得标准输出、标准错误和退出码。

```lisp
(with-input-from-string (input "two words")
  (multiple-value-list (han.os:run-program '("/bin/cat") :input input)))
;; => ("two words" "" 0)
```

直接传 argv 时，用可执行文件的完整路径可在各个后端启动同一程序。只有程序名时，先用 [`han.host:find-executable`](../host/find-executable.zh-CN.md) 查找并检查结果。其余参数按原样传递，包括空格和 shell 符号。

```lisp
(let ((program (or (han.host:find-executable "printf")
                   (error "Cannot find printf"))))
  (han.os:run-program (list program "%s" "a $HOME *")))
;; => values ("a $HOME *" "" 0)
```

要求子程序非零退出时，上层 Lisp 操作也报错。

```lisp
(han.os:run-program '("/bin/sh" "-c" "exit 11") :ignore-error-status nil)
;; signals simple-error
```

[`han.os:run-shell-command`](run-shell-command.zh-CN.md) · [`han.host:run-program-sync`](../host/run-program-sync.zh-CN.md) · [run-shell.lisp](../../../os/run-shell.lisp) · [索引](../README.zh-CN.md)
