# `han.source:char-source-mark-p`

[简体中文](char-source-mark-p.zh-CN.md)

*Predicate*

## Syntax

```text
(han.source:char-source-mark-p object) → boolean
```

## Description

Tests whether `object` is a saved mark. To use it on a particular cursor, check the additional origin constraint with `source-mark-from-source-p`.

## Examples

**Distinguish a saved mark from its running cursor**

```lisp
(let ((src (han.source:make-char-source "42")))
  (list (han.source:char-source-mark-p (han.source:make-source-mark src))
        (han.source:char-source-mark-p src)))
;; => (T NIL)
```

**Find the saved position among mixed parser data**

```lisp
(let ((src (han.source:make-char-source "=42")))
  (han.source:source-next-char src)
  (let ((items (list :equals (han.source:make-source-mark src) src)))
    (han.source:source-location (find-if #'han.source:char-source-mark-p items))))
;; => values (1 1 2)
```

[`han.source:char-source-mark`](char-source-mark.md) · [`han.source:source-mark-from-source-p`](source-mark-from-source-p.md) · [Source](../../../source/char-source.lisp) · [Index](../README.md)
