# `han.source:source-mark-from-source-p`

[简体中文](source-mark-from-source-p.zh-CN.md)

*Predicate*

## Syntax

```text
(han.source:source-mark-from-source-p mark source &optional (report-error nil)) → boolean
```

## Description

Compares the identity stored in `mark` with that of `source`. A mismatch returns false by default and signals an error when `report-error` is true. Comparing the input strings alone cannot establish ownership.

## Examples

**Test a mark against two cursors initialized with the same text**

```lisp
(let* ((a (han.source:make-char-source "id"))
       (b (han.source:make-char-source "id"))
       (mark (han.source:make-source-mark a)))
  (list (han.source:source-mark-from-source-p mark a)
        (han.source:source-mark-from-source-p mark b)))
;; => (T NIL)
```

**Signal a foreign mark when validating parser input**

```lisp
(defparameter *mark*
  (han.source:make-source-mark (han.source:make-char-source "id")))
(defparameter *cursor* (han.source:make-char-source "id"))
(han.source:source-mark-from-source-p *mark* *cursor* t)
;; signals simple-error
```

[`han.source:make-source-mark`](make-source-mark.md) · [`han.source:source-same-origin-p`](source-same-origin-p.md) · [`han.source:source-reset`](source-reset.md) · [Source](../../../source/char-source.lisp) · [Index](../README.md)
