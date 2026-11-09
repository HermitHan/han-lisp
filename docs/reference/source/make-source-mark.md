# `han.source:make-source-mark`

[简体中文](make-source-mark.zh-CN.md)

*Constructor*

## Syntax

```text
(han.source:make-source-mark source) → mark
```

## Description

Captures the current position and source identity without advancing. The saved coordinates survive later reads and can serve as either end of a same-source span.

## Examples

**Compare the saved offset with the cursor after reading one character**

```lisp
(let* ((src (han.source:make-char-source "42"))
       (start (han.source:make-source-mark src)))
  (han.source:source-next-char src)
  (list (han.source:source-location start) (han.source:source-location src)))
;; => (0 1)
```

**Save a position immediately after a newline**

```lisp
(let ((src (han.source:make-char-source (format nil "A~%BC"))))
  (han.source:source-advance-n src 2)
  (let ((line-start (han.source:make-source-mark src)))
    (han.source:source-advance-n src 2)
    (han.source:source-location line-start)))
;; => values (2 2 1)
```

[`han.source:source-location`](source-location.md) · [`han.source:source-reset`](source-reset.md) · [`han.source:make-source-span`](make-source-span.md) · [Source](../../../source/char-source.lisp) · [Index](../README.md)
