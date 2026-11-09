# `han.source:source-slice-by-span`

[简体中文](source-slice-by-span.zh-CN.md)

*Function*

## Syntax

```text
(han.source:source-slice-by-span source span) → string
```

## Description

Copies the substring at the span’s stored offsets. It can be recovered after the cursor has moved or been reset. A span from another origin signals an error.

## Examples

**Save a span around two digits and recover the digits after rewinding**

```lisp
(let* ((src (han.source:make-char-source "42!"))
       (start (han.source:make-source-mark src)))
  (han.source:source-advance-n src 2)
  (let ((digits (han.source:make-source-span start (han.source:make-source-mark src))))
    (han.source:source-reset src start)
    (han.source:source-slice-by-span src digits)))
;; => "42"
```

**Reject a span from another cursor**

```lisp
(defparameter *foreign-span*
  (let* ((original (han.source:make-char-source "A"))
         (mark (han.source:make-source-mark original)))
    (han.source:make-source-span mark mark)))
(defparameter *cursor* (han.source:make-char-source "A"))
(han.source:source-slice-by-span *cursor* *foreign-span*)
;; signals simple-error
```

[`han.source:make-source-span`](make-source-span.md) · [`han.source:source-slice`](source-slice.md) · [`han.source:source-reset`](source-reset.md) · [Source](../../../source/char-source.lisp) · [Index](../README.md)
