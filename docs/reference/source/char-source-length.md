# `han.source:char-source-length`

[简体中文](char-source-length.zh-CN.md)

*Accessor*

## Syntax

```text
(han.source:char-source-length source) → character-count
(setf (han.source:char-source-length source) new-value) → new-value
```

## Description

Returns the length recorded when the source was created, in Lisp characters. Advancing or rewinding the cursor leaves the total unchanged. Treat this slot and the stored input as a pair. The generated writer changes only this slot. To replace the input and initialize its coordinates, create a fresh source.

## Examples

**Check the total length of `汉A` and the cursor’s offset after reading one character**

```lisp
(let ((src (han.source:make-char-source "汉A")))
  (han.source:source-next-char src)
  (list (han.source:char-source-length src) (han.source:source-location src)))
;; => (2 1)
```

**Count the remaining characters after a partial read**

```lisp
(let ((src (han.source:make-char-source (format nil "甲~%BC"))))
  (han.source:source-advance-n src 2)
  (- (han.source:char-source-length src) (han.source:source-location src)))
;; => 2
```

[`han.source:char-source-string`](char-source-string.md) · [`han.source:source-location`](source-location.md) · [`han.source:source-eof-p`](source-eof-p.md) · [Source](../../../source/char-source.lisp) · [Index](../README.md)
