# `han.source:source-span-from-source-p`

[简体中文](source-span-from-source-p.zh-CN.md)

*Predicate*

## Syntax

```text
(han.source:source-span-from-source-p span source &optional (report-error nil)) → boolean
```

## Description

Returns true if `span` was formed from this source’s marks. A false result becomes an error when the optional argument is true. Reading more text in the original source does not invalidate a span.

## Examples

**Check which of two cursors with identical text owns the span**

```lisp
(let* ((src (han.source:make-char-source "x"))
       (mark (han.source:make-source-mark src))
       (span (han.source:make-source-span mark mark)))
  (list (han.source:source-span-from-source-p span src)
        (han.source:source-span-from-source-p span (han.source:make-char-source "x"))))
;; => (T NIL)
```

**Request an error for a mismatched span**

```lisp
(defparameter *span*
  (let* ((original (han.source:make-char-source "x"))
         (mark (han.source:make-source-mark original)))
    (han.source:make-source-span mark mark)))
(defparameter *other-cursor* (han.source:make-char-source "x"))
(han.source:source-span-from-source-p *span* *other-cursor* t)
;; signals simple-error
```

[`han.source:make-source-span`](make-source-span.md) · [`han.source:source-same-origin-p`](source-same-origin-p.md) · [`han.source:source-slice-by-span`](source-slice-by-span.md) · [Source](../../../source/char-source.lisp) · [Index](../README.md)
