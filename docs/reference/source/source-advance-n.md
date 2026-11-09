# `han.source:source-advance-n`

[简体中文](source-advance-n.zh-CN.md)

*Function*

## Syntax

```text
(han.source:source-advance-n source n) → source
```

## Description

Consumes up to `n` characters and returns the same cursor. Supply a nonnegative count. Reaching EOF early is allowed. Newlines update coordinates as with repeated calls to `source-next-char`.

## Examples

**Ask to advance ten characters in a two-character input and inspect the returned cursor**

```lisp
(let ((src (han.source:make-char-source "xy")))
  (list (eq src (han.source:source-advance-n src 10)) (han.source:source-location src)))
;; => (T 2)
```

**Advance across a newline and record the new coordinates**

```lisp
(let ((src (han.source:make-char-source (format nil "x~%yz"))))
  (han.source:source-advance-n src 3)
  (han.source:source-location src))
;; => values (3 2 2)
```

[`han.source:source-next-char`](source-next-char.md) · [`han.source:source-location`](source-location.md) · [`han.source:source-eof-p`](source-eof-p.md) · [Source](../../../source/char-source.lisp) · [Index](../README.md)
