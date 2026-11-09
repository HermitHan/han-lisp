# `han.source:source-reset`

[简体中文](source-reset.zh-CN.md)

*Function*

## Syntax

```text
(han.source:source-reset source mark) → source
```

## Description

Restores all three coordinates from `mark` and returns the same, now repositioned cursor. A mark captured from another source signals an error, including when both sources have equal text.

## Examples

**Rewind to the starting mark and read the first letter again**

```lisp
(let* ((src (han.source:make-char-source "abc"))
       (start (han.source:make-source-mark src)))
  (han.source:source-advance-n src 2)
  (han.source:source-reset src start)
  (han.source:source-next-char src))
;; => #\a
```

**Reject a checkpoint from an identical but separate input**

```lisp
(defparameter *cursor* (han.source:make-char-source "abc"))
(defparameter *foreign-mark*
  (han.source:make-source-mark (han.source:make-char-source "abc")))
(han.source:source-reset *cursor* *foreign-mark*)
;; signals simple-error
```

**Restore line and column after speculative multiline reading**

```lisp
(let* ((src (han.source:make-char-source (format nil "one~%two")))
       (begin (han.source:make-source-mark src)))
  (han.source:source-advance-n src 6)
  (han.source:source-location (han.source:source-reset src begin)))
;; => values (0 1 1)
```

[`han.source:make-source-mark`](make-source-mark.md) · [`han.source:source-location`](source-location.md) · [`han.source:source-mark-from-source-p`](source-mark-from-source-p.md) · [Source](../../../source/char-source.lisp) · [Index](../README.md)
