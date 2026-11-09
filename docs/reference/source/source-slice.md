# `han.source:source-slice`

[简体中文](source-slice.zh-CN.md)

*Function*

## Syntax

```text
(han.source:source-slice source start &optional end) → string
```

## Description

Copies the half-open substring between two nonnegative indices or same-source marks. The default end is the current cursor index. Bounds must fit the stored string. This operation leaves the cursor in place.

## Examples

**Extract the key up to the cursor and peek at the equals sign**

```lisp
(let ((src (han.source:make-char-source "key=17")))
  (han.source:source-advance-n src 3)
  (list (han.source:source-slice src 0) (han.source:source-peek-char src)))
;; => ("key" #\=)
```

**Slice using a saved starting mark and an explicit end offset**

```lisp
(let ((src (han.source:make-char-source "id:42;")))
  (han.source:source-advance-n src 3)
  (let ((start (han.source:make-source-mark src)))
    (values (han.source:source-slice src start 5) (han.source:source-location src))))
;; => values ("42" 3)
```

**Reject a boundary from a different parse**

```lisp
(defparameter *cursor* (han.source:make-char-source "xy"))
(defparameter *foreign-mark*
  (han.source:make-source-mark (han.source:make-char-source "xy")))
(han.source:source-slice *cursor* *foreign-mark* 1)
;; signals simple-error
```

[`han.source:source-slice-by-span`](source-slice-by-span.md) · [`han.source:make-source-mark`](make-source-mark.md) · [`han.source:source-location`](source-location.md) · [Source](../../../source/char-source.lisp) · [Index](../README.md)
