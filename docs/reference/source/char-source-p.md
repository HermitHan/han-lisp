# `han.source:char-source-p`

[简体中文](char-source-p.zh-CN.md)

*Predicate*

## Syntax

```text
(han.source:char-source-p object) → boolean
```

## Description

Recognizes character-source structures. A saved position is a separate type even though it can also be passed to `source-location`.

## Examples

**Recognize the cursor when given either a cursor or a mark**

```lisp
(let ((src (han.source:make-char-source "a")))
  (list (han.source:char-source-p src)
        (han.source:char-source-p (han.source:make-source-mark src))))
;; => (T NIL)
```

**Reuse a caller’s cursor at its current position**

```lisp
(let ((cursor (han.source:make-char-source "v2")))
  (han.source:source-next-char cursor)
  (flet ((as-source (x) (if (han.source:char-source-p x) x (han.source:make-char-source x))))
    (mapcar (lambda (x) (han.source:source-peek-char (as-source x)))
            (list cursor "v2"))))
;; => (#\2 #\v)
```

[`han.source:char-source`](char-source.md) · [`han.source:char-source-mark-p`](char-source-mark-p.md) · [Source](../../../source/char-source.lisp) · [Index](../README.md)
