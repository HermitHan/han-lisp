# `han.os:run-program`

*Function · 函数*

## Syntax · 语法

```text
(han.os:run-program command &key input (output :string) (error-output :string) (ignore-error-status t)) → stdout, stderr, exit-code
```

## Description · 说明

Runs a program synchronously through `han.host:run-program-sync`. A list of strings supplies argv and a command string uses shell syntax. By default stdin sees EOF and both outputs are captured as strings. Pass a character input stream to send literal text. Nonzero integer exit codes are returned by default or signal an error if `ignore-error-status` is `nil`. Redirected output streams receive their text after completion.

通过 `han.host:run-program-sync` 同步执行。字符串列表表示 argv，命令字符串按 shell 语法解释。默认 stdin 读到 EOF，两路输出各自捕获为字符串。发送文本时可传入字符输入流。默认返回非零整数退出码，将 `ignore-error-status` 设为 `nil` 时则触发错误。指定输出流时会在运行完成后重放文本。

## Examples · 示例

Send a string to `cat` and collect standard output, standard error and the exit code.

把字符串传给 `cat`，并分别取得标准输出、标准错误和退出码。

```lisp
(with-input-from-string (input "two words")
  (multiple-value-list (han.os:run-program '("/bin/cat") :input input)))
;; => ("two words" "" 0)
```

Forward literal argv without quoting spaces or shell metacharacters inside an argument.

直接传 argv，参数中的空格和 shell 符号无需额外加引号。

```lisp
(han.os:run-program '("/usr/bin/printf" "%s" "a $HOME *"))
;; => values ("a $HOME *" "" 0)
```

Make a nonzero worker exit fail the enclosing Lisp operation.

要求子程序非零退出时，上层 Lisp 操作也报错。

```lisp
(han.os:run-program '("/bin/sh" "-c" "exit 11") :ignore-error-status nil)
;; signals simple-error
```

[`han.os:run-shell-command`](run-shell-command.md) · [`han.host:run-program-sync`](../host/run-program-sync.md) · [run-shell.lisp](../../../os/run-shell.lisp) · [Index · 索引](../README.md)
