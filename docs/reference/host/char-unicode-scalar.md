# `han.host:char-unicode-scalar`

[简体中文](char-unicode-scalar.zh-CN.md)

*Function*

## Syntax

```text
(han.host:char-unicode-scalar char) → integer or nil
```

## Description

Returns the Unicode scalar for a Lisp character, or `nil` when its mapping is unknown or the character corresponds to a surrogate. A non-character signals `type-error`. Use this operation when an external format needs a Unicode value: ANSI Common Lisp does not require the number returned by `char-code` to be a Unicode value.

## Examples

Read the scalar for an ASCII character.

```lisp
(han.host:char-unicode-scalar #\A)
;; => 65
```

Read a JSON surrogate pair and recover the single scalar it encodes on a Unicode-capable host.

```lisp
(let ((text (han.json:parse-json "\"\\uD83D\\uDE00\"")))
  (han.host:char-unicode-scalar (char text 0)))
;; => #x1F600
```

The argument must be a character; a one-character string is still a string.

```lisp
(han.host:char-unicode-scalar "A")
;; signals type-error
```

[`han.host:unicode-scalar-char`](unicode-scalar-char.md) · [characters.lisp](../../../host/characters.lisp) · [Index](../README.md)
