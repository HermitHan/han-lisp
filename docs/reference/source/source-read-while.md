# `han.source:source-read-while`

[简体中文](source-read-while.zh-CN.md)

*Function*

## Syntax

```text
(han.source:source-read-while source predicate) → string
```

## Description

Consumes a consecutive run of characters satisfying the predicate and returns their text. The first rejected character stays in the input. An immediate mismatch or EOF produces an empty string.

## Examples

**Read a sequence of port digits and leave the slash for the next step**

```lisp
(let ((src (han.source:make-char-source "8080/tcp")))
  (list (han.source:source-read-while src #'digit-char-p) (han.source:source-peek-char src)))
;; => ("8080" #\/)
```

**A rejected first character stays available for another branch**

```lisp
(let ((src (han.source:make-char-source "-12")))
  (values (han.source:source-read-while src #'digit-char-p)
          (han.source:source-consume-char-if src #\-)
          (han.source:source-read-while src #'digit-char-p)))
;; => values ("" #\- "12")
```

[`han.source:source-skip-while`](source-skip-while.md) · [`han.source:source-peek-char`](source-peek-char.md) · [`han.source:source-slice`](source-slice.md) · [Source](../../../source/char-source.lisp) · [Index](../README.md)
