# `han.host:escape-sh-token`

[简体中文](escape-sh-token.zh-CN.md)

*Function*

## Syntax

```text
(han.host:escape-sh-token value) → quoted-token string
```

## Description

Converts `value` with `princ-to-string` (using the empty string for `nil`) and quotes the result as a single POSIX shell word. It escapes internal apostrophes. Use it when constructing shell text. For an argv list, pass the original argument.

## Examples

Quote an argument containing a space and an empty argument for a shell command.

```lisp
(list (han.host:escape-sh-token "x y") (han.host:escape-sh-token nil))
;; => ("'x y'" "''")
```

Preserve literal apostrophes, whitespace, and a dollar sign across a real shell invocation.

```lisp
(han.host:run-program-sync
 (list "/bin/sh" "-c" (format nil "printf '%s' ~A" (han.host:escape-sh-token "Kai's $x"))))
;; => values ("Kai's $x" "" 0)
```

[`han.os:run-shell-command`](../os/run-shell-command.md) · [`han.host:run-program-sync`](run-program-sync.md) · [common.lisp](../../../host/common.lisp) · [Index](../README.md)
