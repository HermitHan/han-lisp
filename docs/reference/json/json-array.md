# `han.json:json-array`

[简体中文](json-array.zh-CN.md)

*Function*

## Syntax

```text
(han.json:json-array &rest values) → vector
```

## Description

Collect the arguments, in order, into a vector. With no arguments the result represents `[]`. Lisp `nil` supplied as an element encodes as JSON `false`. The constructor accepts Lisp objects as elements, and JSON encoding later checks whether it can write them.

## Examples

Mix a string, false and null in one row.

```lisp
(let ((row (han.json:json-array "read" nil :null)))
  (list (aref row 0) (han.json:encode-json row :indent nil)))
;; => ("read" "[\"read\",false,null]")
```

An empty collection and a false flag have different encodings.

```lisp
(mapcar (lambda (value) (han.json:encode-json value :indent nil))
        (list (han.json:json-array) nil))
;; => ("[]" "false")
```

[`json-array-p`](json-array-p.md) · [`encode-json`](encode-json.md) · [Source](../../../json/core.lisp#L24) · [Index](../README.md)
