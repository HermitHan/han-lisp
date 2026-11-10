# `han.host:unicode-scalar-char`

[简体中文](unicode-scalar-char.zh-CN.md)

*Function*

## Syntax

```text
(han.host:unicode-scalar-char code) → character or nil
```

## Description

Maps one Unicode scalar value to one Lisp character. Returns `nil` for a non-integer, a value outside U+0000–U+10FFFF, a surrogate (U+D800–U+DFFF), or a scalar the host cannot map. Pass a complete scalar such as `#x1F600`; a UTF-16 surrogate pair must first be combined into that scalar.

## Examples

Get the letter A from its Unicode value.

```lisp
(han.host:unicode-scalar-char #x41)
;; => #\A
```

A high surrogate alone does not represent a character.

```lisp
(han.host:unicode-scalar-char #xD83D)
;; => NIL
```

On CCL 1.14, Unicode-enabled ECL, Unicode-capable SBCL or LispWorks 8, U+1F600 is one character in a Lisp string.

```lisp
(length (string (han.host:unicode-scalar-char #x1F600)))
;; => 1
```

[`han.host:char-unicode-scalar`](char-unicode-scalar.md) · [characters.lisp](../../../host/characters.lisp) · [Index](../README.md)
