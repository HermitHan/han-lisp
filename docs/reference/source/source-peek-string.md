# `han.source:source-peek-string`

[简体中文](source-peek-string.zh-CN.md)

*Function*

## Syntax

```text
(han.source:source-peek-string source n) → string
```

## Description

Returns up to `n` characters starting at the cursor. Use a nonnegative integer. If the remaining input is shorter, the result ends at EOF. At EOF the result is an empty string. The cursor does not move.

## Examples

**Request five characters when only two colons remain**

```lisp
(let ((src (han.source:make-char-source "x::")))
  (han.source:source-next-char src)
  (list (han.source:source-peek-string src 5) (han.source:source-location src)))
;; => ("::" 1)
```

**Ask for a zero-length preview before consuming input**

```lisp
(let ((src (han.source:make-char-source "word")))
  (values (han.source:source-peek-string src 0) (han.source:source-next-char src)))
;; => values ("" #\w)
```

[`han.source:source-peek-char`](source-peek-char.md) · [`han.source:source-match-string-p`](source-match-string-p.md) · [Source](../../../source/char-source.lisp) · [Index](../README.md)
