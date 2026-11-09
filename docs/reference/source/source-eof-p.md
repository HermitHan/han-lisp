# `han.source:source-eof-p`

[简体中文](source-eof-p.zh-CN.md)

*Predicate*

## Syntax

```text
(han.source:source-eof-p source) → boolean
```

## Description

Tests whether the cursor index has reached the recorded input length. An empty input is at EOF immediately. Peeking at EOF leaves the result unchanged.

## Examples

**Check for end of input before and after reading the only character**

```lisp
(let ((src (han.source:make-char-source "x")))
  (list (han.source:source-eof-p src) (han.source:source-next-char src) (han.source:source-eof-p src)))
;; => (NIL #\x T)
```

**An empty field starts at EOF**

```lisp
(let ((src (han.source:make-char-source "")))
  (values (han.source:source-eof-p src) (han.source:source-peek-string src 4)))
;; => values (T "")
```

[`han.source:source-peek-char`](source-peek-char.md) · [`han.source:source-next-char`](source-next-char.md) · [Source](../../../source/char-source.lisp) · [Index](../README.md)
