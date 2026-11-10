# `han.host:unicode-scalar-char`

[English](unicode-scalar-char.md)

*函数*

## 语法

```text
(han.host:unicode-scalar-char code) → character or nil
```

## 说明

将一个 Unicode 标量值映射为一个 Lisp 字符。非整数、超出 U+0000–U+10FFFF 的值、代理码（U+D800–U+DFFF），以及宿主无法映射的标量，都返回 `nil`。参数应是完整的标量值，例如 `#x1F600`；如果输入是 UTF-16 代理对，要先合并为标量。

## 示例

由 Unicode 值取得字母 A。

```lisp
(han.host:unicode-scalar-char #x41)
;; => #\A
```

单独的高代理码不表示一个字符。

```lisp
(han.host:unicode-scalar-char #xD83D)
;; => NIL
```

在 CCL 1.14、启用 Unicode 的 ECL、支持 Unicode 的 SBCL 或 LispWorks 8 上，U+1F600 在 Lisp 字符串中只占一个字符。

```lisp
(length (string (han.host:unicode-scalar-char #x1F600)))
;; => 1
```

[`han.host:char-unicode-scalar`](char-unicode-scalar.zh-CN.md) · [characters.lisp](../../../host/characters.lisp) · [索引](../README.zh-CN.md)
