# `han.source:char-source-span`

[简体中文](char-source-span.zh-CN.md)

*Structure type*

## Syntax

```text
han.source:char-source-span
```

## Description

A half-open range of character offsets from one origin. Construct it from two marks and give it back to the originating cursor to recover the exact matched text.

## Examples

**Consume one character and check the type of the span between the two marks**

```lisp
(let* ((src (han.source:make-char-source "ab"))
       (start (han.source:make-source-mark src)))
  (han.source:source-next-char src)
  (typep (han.source:make-source-span start (han.source:make-source-mark src)) 'han.source:char-source-span))
;; => T
```

**Carry the token range past a rewind**

```lisp
(let* ((src (han.source:make-char-source "42:"))
       (begin (han.source:make-source-mark src)))
  (han.source:source-read-while src #'digit-char-p)
  (let ((token (han.source:make-source-span begin (han.source:make-source-mark src))))
    (han.source:source-reset src begin)
    (etypecase token
      (han.source:char-source-span (han.source:source-slice-by-span src token)))))
;; => "42"
```

[`han.source:make-source-span`](make-source-span.md) · [`han.source:source-slice-by-span`](source-slice-by-span.md) · [`han.source:char-source-span-p`](char-source-span-p.md) · [Source](../../../source/char-source.lisp) · [Index](../README.md)
