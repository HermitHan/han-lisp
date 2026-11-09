# `han.source:source-location`

[简体中文](source-location.zh-CN.md)

*Function*

## Syntax

```text
(han.source:source-location source-or-mark) → index, line, column
```

## Description

Returns three integers for a cursor or saved mark. Index counts characters consumed from zero. Lines and columns start at one. A newline advances the line and resets the column to one. A span is outside the accepted input types.

## Examples

**Read through a newline and inspect the index, line and column**

```lisp
(let ((src (han.source:make-char-source (format nil "ab~%cd"))))
  (han.source:source-advance-n src 3)
  (multiple-value-list (han.source:source-location src)))
;; => (3 2 1)
```

**Locate an earlier mark after reading the rest of a line**

```lisp
(let ((src (han.source:make-char-source "key=1")))
  (han.source:source-advance-n src 3)
  (let ((separator (han.source:make-source-mark src)))
    (han.source:source-advance-n src 2)
    (han.source:source-location separator)))
;; => values (3 1 4)
```

**A span has two boundaries and is rejected as a location**

```lisp
(defparameter *span*
  (let* ((src (han.source:make-char-source ""))
         (mark (han.source:make-source-mark src)))
    (han.source:make-source-span mark mark)))
(han.source:source-location *span*)
;; signals simple-error
```

[`han.source:make-source-mark`](make-source-mark.md) · [`han.source:source-next-char`](source-next-char.md) · [`han.source:source-reset`](source-reset.md) · [Source](../../../source/char-source.lisp) · [Index](../README.md)
