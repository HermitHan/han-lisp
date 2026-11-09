# `han.source:source-next-char`

[简体中文](source-next-char.zh-CN.md)

*Function*

## Syntax

```text
(han.source:source-next-char source) → character-or-nil
```

## Description

Returns and consumes the current character. At EOF it returns `nil` without advancing. A newline advances the line and resets the column to one, so diagnostic positions remain in step with consumption.

## Examples

**Read a newline, inspect the new coordinates and try one more read at end of input**

```lisp
(let ((src (han.source:make-char-source (string #\Newline))))
  (list (han.source:source-next-char src) (multiple-value-list (han.source:source-location src))
        (han.source:source-next-char src)))
;; => (#\Newline (1 2 1) NIL)
```

**Repeated reads at EOF preserve all coordinates**

```lisp
(let ((src (han.source:make-char-source "A")))
  (han.source:source-next-char src)
  (han.source:source-next-char src)
  (values (han.source:source-next-char src) (multiple-value-list (han.source:source-location src))))
;; => values (NIL (1 1 2))
```

[`han.source:source-peek-char`](source-peek-char.md) · [`han.source:source-location`](source-location.md) · [`han.source:source-advance-n`](source-advance-n.md) · [Source](../../../source/char-source.lisp) · [Index](../README.md)
