# `han.os:escape-sh-token`

*Function · 函数*

## Syntax · 语法

```text
(han.os:escape-sh-token value) → quoted-token string
```

## Description · 说明

Quotes a value as a single POSIX shell word by delegating to `han.host:escape-sh-token`. The result includes the surrounding quotes, and an embedded apostrophe is escaped. `nil` represents an empty string. Use the returned text only when assembling shell syntax.

委托 `han.host:escape-sh-token` 将值引用成一个 POSIX shell 词。结果包括首尾引号，内部单引号会被转义，`nil` 表示空字符串。返回值用于构造 shell 文本。

## Examples · 示例

Pass an apostrophe and a literal dollar sign through the shell as part of one argument.

将含单引号和美元符号的文本作为一个实参传给 shell，保留字符原样。

```lisp
(multiple-value-list
 (han.os:run-shell-command
  (format nil "printf '%s' ~A" (han.os:escape-sh-token "l'été $HOME"))
  :shell "/bin/sh" :lines nil))
;; => ("l'été $HOME" "" 0)
```

Preserve an empty positional argument between two nonempty arguments.

将空参数放在两个非空参数之间，保持其位置和值。

```lisp
(let ((quoted (mapcar #'han.os:escape-sh-token '("one" "" "three"))))
  (han.os:run-shell-command (format nil "printf '<%s>' ~{~A~^ ~}" quoted)
                            :shell "/bin/sh" :lines nil))
;; => values ("<one><><three>" "" 0)
```

[`han.os:run-shell-command`](run-shell-command.md) · [`han.host:escape-sh-token`](../host/escape-sh-token.md) · [run-shell.lisp](../../../os/run-shell.lisp) · [Index · 索引](../README.md)
