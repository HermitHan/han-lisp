# `han.source:source-same-origin-p`

[简体中文](source-same-origin-p.zh-CN.md)

*Predicate*

## Syntax

```text
(han.source:source-same-origin-p target &rest others) → boolean
```

## Description

Checks the origins of any mixture of cursors, marks and spans. A single valid argument succeeds. The comparison uses the identity assigned at construction and accepts only these three types.

## Examples

**Check the shared origin of a cursor, its mark and an empty span**

```lisp
(let* ((src (han.source:make-char-source "ab"))
       (mark (han.source:make-source-mark src))
       (span (han.source:make-source-span mark mark)))
  (han.source:source-same-origin-p src mark span))
;; => T
```

**Compare ranges from independently parsed copies of the same text**

```lisp
(flet ((empty-span (src)
         (let ((m (han.source:make-source-mark src))) (han.source:make-source-span m m))))
  (han.source:source-same-origin-p (empty-span (han.source:make-char-source "x"))
                         (empty-span (han.source:make-char-source "x"))))
;; => NIL
```

[`han.source:source-mark-from-source-p`](source-mark-from-source-p.md) · [`han.source:source-span-from-source-p`](source-span-from-source-p.md) · [Source](../../../source/char-source.lisp) · [Index](../README.md)
