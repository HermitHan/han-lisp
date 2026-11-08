# `han.host:char-unicode-scalar`

*Function · 函数*

## Syntax · 语法

```text
(han.host:char-unicode-scalar char) → integer or nil
```

## Description · 说明

Returns the Unicode scalar for a Lisp character, or `nil` when its mapping is unknown or the character corresponds to a surrogate. A non-character signals `type-error`. Use this operation when an external format needs a Unicode value: ANSI Common Lisp does not require the number returned by `char-code` to be a Unicode value.

返回 Lisp 字符对应的 Unicode 标量；映射未知，或者字符对应代理码时返回 `nil`。传入非字符会触发 `type-error`。外部格式需要 Unicode 值时可用此函数：ANSI Common Lisp 不保证 `char-code` 给出的编号就是 Unicode 值。

## Examples · 示例

Read the scalar for an ASCII character.

读取一个 ASCII 字符的标量值。

```lisp
(han.host:char-unicode-scalar #\A)
;; => 65
```

Read a JSON surrogate pair and recover the single scalar it encodes on a Unicode-capable host.

在支持 Unicode 的宿主上解析 JSON 代理对，再取出它编码的单个标量值。

```lisp
(let ((text (han.json:parse-json "\"\\uD83D\\uDE00\"")))
  (han.host:char-unicode-scalar (char text 0)))
;; => #x1F600
```

The argument must be a character; a one-character string is still a string.

参数必须是字符，即使只有一个字符的字符串也不能直接传入。

```lisp
(han.host:char-unicode-scalar "A")
;; signals type-error
```

[`han.host:unicode-scalar-char`](unicode-scalar-char.md) · [characters.lisp](../../../host/characters.lisp) · [Index · 索引](../README.md)
