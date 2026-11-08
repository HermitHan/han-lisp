# `han.host:unicode-scalar-char`

*Function · 函数*

## Syntax · 语法

```text
(han.host:unicode-scalar-char code) → character or nil
```

## Description · 说明

Maps one Unicode scalar value to one Lisp character. Returns `nil` for a non-integer, a value outside U+0000–U+10FFFF, a surrogate (U+D800–U+DFFF), or a scalar the host cannot map. Pass a complete scalar such as `#x1F600`; a UTF-16 surrogate pair must first be combined into that scalar.

将一个 Unicode 标量值映射为一个 Lisp 字符。非整数、超出 U+0000–U+10FFFF 的值、代理码（U+D800–U+DFFF），以及宿主无法映射的标量，都返回 `nil`。参数应是完整的标量值，例如 `#x1F600`；如果输入是 UTF-16 代理对，要先合并为标量。

## Examples · 示例

Get the letter A from its Unicode value.

由 Unicode 值取得字母 A。

```lisp
(han.host:unicode-scalar-char #x41)
;; => #\A
```

A high surrogate alone does not represent a character.

单独的高代理码不表示一个字符。

```lisp
(han.host:unicode-scalar-char #xD83D)
;; => NIL
```

On a Unicode-capable SBCL or LispWorks 8, U+1F600 is one character in a Lisp string.

在支持 Unicode 的 SBCL 或 LispWorks 8 上，U+1F600 在 Lisp 字符串中只占一个字符。

```lisp
(length (string (han.host:unicode-scalar-char #x1F600)))
;; => 1
```

[`han.host:char-unicode-scalar`](char-unicode-scalar.md) · [characters.lisp](../../../host/characters.lisp) · [Index · 索引](../README.md)
