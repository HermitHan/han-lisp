# `han.source:char-source-string`

[简体中文](char-source-string.zh-CN.md)

*Accessor*

## Syntax

```text
(han.source:char-source-string source) → string
(setf (han.source:char-source-string source) new-value) → new-value
```

## Description

Returns the cursor’s stored string, including the text before its current position. Reading this slot does not copy it. Treat it as read-only after construction so that saved positions still identify the same text. The generated writer changes only this slot. To replace the input and initialize its coordinates, create a fresh source.

## Examples

**Recover the full input after passing the colon**

```lisp
(let ((src (han.source:make-char-source "alpha:beta")))
  (han.source:source-advance-n src 6)
  (han.source:char-source-string src))
;; => "alpha:beta"
```

**Two cursors constructed from one input own distinct copies**

```lisp
(let* ((input (copy-seq "AC"))
       (a (han.source:make-char-source input))
       (b (han.source:make-char-source input)))
  (list (string= (han.source:char-source-string a) (han.source:char-source-string b))
        (eq (han.source:char-source-string a) (han.source:char-source-string b))))
;; => (T NIL)
```

[`han.source:make-char-source`](make-char-source.md) · [`han.source:source-slice`](source-slice.md) · [`han.source:char-source-length`](char-source-length.md) · [Source](../../../source/char-source.lisp) · [Index](../README.md)
