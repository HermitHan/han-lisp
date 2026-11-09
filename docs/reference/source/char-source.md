# `han.source:char-source`

[简体中文](char-source.zh-CN.md)

*Structure type*

## Syntax

```text
han.source:char-source
```

## Description

A structure type for a mutable cursor over an owned string. A cursor tracks its current index, line, column and a unique identity used to check marks and spans. Create one with `make-char-source`.

## Examples

**Check that a string-backed cursor has type `char-source`**

```lisp
(typep (han.source:make-char-source "key=value") 'han.source:char-source)
;; => T
```

**Dispatch on cursor or string input**

```lisp
(flet ((first-char (input)
         (etypecase input
           (han.source:char-source (han.source:source-peek-char input))
           (string (and (plusp (length input)) (char input 0))))))
  (mapcar #'first-char (list (han.source:make-char-source "8080") "tcp" "")))
;; => (#\8 #\t NIL)
```

[`han.source:make-char-source`](make-char-source.md) · [`han.source:char-source-p`](char-source-p.md) · [`han.source:source-location`](source-location.md) · [Source](../../../source/char-source.lisp) · [Index](../README.md)
