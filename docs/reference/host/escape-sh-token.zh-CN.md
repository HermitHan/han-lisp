# `han.host:escape-sh-token`

[English](escape-sh-token.md)

*函数*

## 语法

```text
(han.host:escape-sh-token value) → quoted-token string
```

## 说明

使用 `princ-to-string` 转为文本，`nil` 按空字符串处理，再用引号包成一个 POSIX shell 词，转义内部单引号。构造 shell 文本时使用此函数；传 argv 列表时可直接传原参数。

## 示例

为 shell 命令中的带空格参数和空参数加上引号。

```lisp
(list (han.host:escape-sh-token "x y") (han.host:escape-sh-token nil))
;; => ("'x y'" "''")
```

将含单引号、空格和美元符号的参数经过真实 shell 后原样读回。

```lisp
(han.host:run-program-sync
 (list "/bin/sh" "-c" (format nil "printf '%s' ~A" (han.host:escape-sh-token "Kai's $x"))))
;; => values ("Kai's $x" "" 0)
```

[`han.os:run-shell-command`](../os/run-shell-command.zh-CN.md) · [`han.host:run-program-sync`](run-program-sync.zh-CN.md) · [common.lisp](../../../host/common.lisp) · [索引](../README.zh-CN.md)
