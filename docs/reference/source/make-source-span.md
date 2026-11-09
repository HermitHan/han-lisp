# `han.source:make-source-span`

[简体中文](make-source-span.zh-CN.md)

*Constructor*

## Syntax

```text
(han.source:make-source-span start-mark end-mark) → span
```

## Description

Constructs the range from the first mark up to, and excluding, the second. The marks must have the same origin and nondecreasing offsets. Either violation signals an error. Equal offsets produce an empty range.

## Examples

**Mark both ends of the name in `id=7` and extract it**

```lisp
(let* ((src (han.source:make-char-source "id=7"))
       (start (han.source:make-source-mark src)))
  (han.source:source-read-while src #'alpha-char-p)
  (han.source:source-slice-by-span src (han.source:make-source-span start (han.source:make-source-mark src))))
;; => "id"
```

**Represent an empty field between delimiters**

```lisp
(let* ((src (han.source:make-char-source "::"))
       (field-start (progn (han.source:source-next-char src) (han.source:make-source-mark src))))
  (han.source:source-slice-by-span src (han.source:make-source-span field-start field-start)))
;; => ""
```

**Reject endpoints supplied in reverse order**

```lisp
(defparameter *cursor* (han.source:make-char-source "id"))
(defparameter *begin* (han.source:make-source-mark *cursor*))
(han.source:source-next-char *cursor*)
(defparameter *end* (han.source:make-source-mark *cursor*))
(han.source:make-source-span *end* *begin*)
;; signals simple-error
```

[`han.source:make-source-mark`](make-source-mark.md) · [`han.source:source-slice-by-span`](source-slice-by-span.md) · [`han.source:source-span-from-source-p`](source-span-from-source-p.md) · [Source](../../../source/char-source.lisp) · [Index](../README.md)
