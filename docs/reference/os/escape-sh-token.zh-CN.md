# `han.os:escape-sh-token`

[English](escape-sh-token.md)

*函数*

## 语法

```text
(han.os:escape-sh-token value) → quoted-token string
```

## 说明

委托 `han.host:escape-sh-token` 将值引用成一个 POSIX shell 词。结果包括首尾引号，内部单引号会被转义，`nil` 表示空字符串。返回值用于构造 shell 文本。

## 示例

用两种方式把同一文本传进 shell，一次嵌入命令文本，一次单独传作实参。shell 比较其中的重音字母、单引号、空格与美元符号，再用退出码报告结果。若要捕获子进程的文本输出，捕获时采用宿主的默认外部编码。

```lisp
(let ((word "l'été $HOME"))
  (han.os:run-program
   (list "/bin/sh" "-c"
         (format nil "test ~A = \"$1\"" (han.os:escape-sh-token word))
         "check-word" word)))
;; => values ("" "" 0)
```

将空参数放在两个非空参数之间，保持其位置和值。

```lisp
(let ((quoted (mapcar #'han.os:escape-sh-token '("one" "" "three"))))
  (han.os:run-shell-command (format nil "printf '<%s>' ~{~A~^ ~}" quoted)
                            :shell "/bin/sh" :lines nil))
;; => values ("<one><><three>" "" 0)
```

[`han.os:run-shell-command`](run-shell-command.zh-CN.md) · [`han.host:escape-sh-token`](../host/escape-sh-token.zh-CN.md) · [run-shell.lisp](../../../os/run-shell.lisp) · [索引](../README.zh-CN.md)
