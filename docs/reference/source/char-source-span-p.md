# `han.source:char-source-span-p`

[简体中文](char-source-span-p.zh-CN.md)

*Predicate*

## Syntax

```text
(han.source:char-source-span-p object) → boolean
```

## Description

Tests whether an object is a span. Even two coincident marks produce a valid, empty span. To check ownership, use `source-span-from-source-p`.

## Examples

**Distinguish an empty span from the mark used to create it**

```lisp
(let* ((src (han.source:make-char-source ""))
       (mark (han.source:make-source-mark src)))
  (list (han.source:char-source-span-p (han.source:make-source-span mark mark))
        (han.source:char-source-span-p mark)))
;; => (T NIL)
```

**Collect just the matched text ranges**

```lisp
(let* ((src (han.source:make-char-source "id=3"))
       (start (han.source:make-source-mark src)))
  (han.source:source-advance-n src 2)
  (let ((items (list start :name (han.source:make-source-span start (han.source:make-source-mark src)))))
    (mapcar (lambda (span) (han.source:source-slice-by-span src span))
            (remove-if-not #'han.source:char-source-span-p items))))
;; => ("id")
```

[`han.source:char-source-span`](char-source-span.md) · [`han.source:source-span-from-source-p`](source-span-from-source-p.md) · [Source](../../../source/char-source.lisp) · [Index](../README.md)
