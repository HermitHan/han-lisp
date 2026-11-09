# `han.source:char-source-mark`

[简体中文](char-source-mark.zh-CN.md)

*Structure type*

## Syntax

```text
han.source:char-source-mark
```

## Description

A saved position containing an origin and the cursor’s index, line and column at the time of capture. Use it to return to a parsing decision or to bound a slice. Create it with `make-source-mark`.

## Examples

**Check the type of a mark saved at the start of the input**

```lisp
(let ((src (han.source:make-char-source "42")))
  (typep (han.source:make-source-mark src) 'han.source:char-source-mark))
;; => T
```

**Read coordinates from either a cursor or a saved mark**

```lisp
(let* ((src (han.source:make-char-source "a:"))
       (before (han.source:make-source-mark src)))
  (han.source:source-next-char src)
  (mapcar (lambda (x)
            (etypecase x
              (han.source:char-source-mark (list :saved (han.source:source-location x)))
              (han.source:char-source (list :current (han.source:source-location x)))))
          (list before src)))
;; => ((:SAVED 0) (:CURRENT 1))
```

[`han.source:make-source-mark`](make-source-mark.md) · [`han.source:source-reset`](source-reset.md) · [`han.source:source-slice`](source-slice.md) · [Source](../../../source/char-source.lisp) · [Index](../README.md)
