# `han.json:json-array-p`

[简体中文](json-array-p.zh-CN.md)

*Function*

## Syntax

```text
(han.json:json-array-p value) → boolean
```

## Description

Recognize a vector whose type is not a string. The predicate checks the container type, including the empty vector, without examining elements. Use `length` and `aref` to access a parsed array.

## Examples

Recognize the empty JSON array among other Lisp sequences.

```lisp
(mapcar #'han.json:json-array-p
        (list (han.json:parse-json "[]") "abc" '(1 2)))
;; => (T NIL NIL)
```

A specialized numeric vector can also supply array elements to the encoder.

```lisp
(let ((bits #*101))
  (list (han.json:json-array-p bits)
        (han.json:encode-json bits :indent nil)))
;; => (T "[1,0,1]")
```

[`json-array`](json-array.md) · [`json-object-p`](json-object-p.md) · [Source](../../../json/core.lisp#L31) · [Index](../README.md)
