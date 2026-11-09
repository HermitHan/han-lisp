# `han.source:source-peek-char`

[简体中文](source-peek-char.zh-CN.md)

*Function*

## Syntax

```text
(han.source:source-peek-char source) → character-or-nil
```

## Description

Reads the character at the current index without advancing. Returns `nil` at EOF. Repeated peeks let a parser decide which branch should consume the character.

## Examples

**Peek at the same equals sign twice and check the offset**

```lisp
(let ((src (han.source:make-char-source "=8")))
  (list (han.source:source-peek-char src) (han.source:source-peek-char src) (han.source:source-location src)))
;; => (#\= #\= 0)
```

**Peeking at an empty source returns immediately**

```lisp
(let ((src (han.source:make-char-source "")))
  (values (han.source:source-peek-char src) (han.source:source-eof-p src)))
;; => values (NIL T)
```

[`han.source:source-next-char`](source-next-char.md) · [`han.source:source-peek-string`](source-peek-string.md) · [Source](../../../source/char-source.lisp) · [Index](../README.md)
