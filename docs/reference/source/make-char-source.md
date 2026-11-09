# `han.source:make-char-source`

[简体中文](make-char-source.zh-CN.md)

*Constructor*

## Syntax

```text
(han.source:make-char-source string) → source
```

## Description

Copies `string` and creates a cursor at character index 0, line 1, column 1. Every call creates a new origin, including calls with identical text. A non-string argument signals a type error.

## Examples

**Change the caller’s string and inspect the new cursor’s text and starting coordinates**

```lisp
(let* ((input (copy-seq "red"))
       (src (han.source:make-char-source input)))
  (setf (char input 0) #\b)
  (list (han.source:char-source-string src)
        (multiple-value-list (han.source:source-location src))))
;; => ("red" (0 1 1))
```

**Reject a list of characters as input**

```lisp
(han.source:make-char-source (list #\a #\b))
;; signals type-error
```

[`han.source:char-source`](char-source.md) · [`han.source:char-source-string`](char-source-string.md) · [`han.source:source-same-origin-p`](source-same-origin-p.md) · [Source](../../../source/char-source.lisp) · [Index](../README.md)
