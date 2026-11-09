# `han.source:source-skip-while`

[简体中文](source-skip-while.zh-CN.md)

*Function*

## Syntax

```text
(han.source:source-skip-while source predicate) → source
```

## Description

Calls the predicate on each next character and advances while the result is true. Leaves the first rejected character available and returns the cursor. At EOF the predicate is not called.

## Examples

**Skip leading spaces and peek at the start of the name**

```lisp
(let ((src (han.source:make-char-source "   name")))
  (han.source:source-skip-while src (lambda (ch) (char= ch #\Space)))
  (han.source:source-peek-char src))
;; => #\n
```

**Skip whitespace up to EOF across a newline**

```lisp
(let ((src (han.source:make-char-source (format nil " ~% "))))
  (han.source:source-skip-while src (lambda (ch) (member ch '(#\Space #\Newline))))
  (han.source:source-location src))
;; => values (3 2 2)
```

[`han.source:source-read-while`](source-read-while.md) · [`han.source:source-peek-char`](source-peek-char.md) · [Source](../../../source/char-source.lisp) · [Index](../README.md)
