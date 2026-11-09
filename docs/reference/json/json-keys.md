# `han.json:json-keys`

[简体中文](json-keys.zh-CN.md)

*Function*

## Syntax

```text
(han.json:json-keys object) → keys
```

## Description

Return a sorted list of the object’s keys using `string<`. An empty object gives `nil`. Han objects have string keys and the writer uses this same ordering for serialization. Passing a non-object signals `json-error`.

## Examples

List keys in the order used when encoding an object.

```lisp
(han.json:json-keys (han.json:parse-json "{\"z\":1,\"a\":0}"))
;; => ("a" "z")
```

A document with no fields yields an empty key list.

```lisp
(han.json:json-keys (han.json:json-object))
;; => NIL
```

An array must be traversed by index.

```lisp
(han.json:json-keys (han.json:json-array "Ada"))
;; signals han.json:json-error
```

[`json-object-p`](json-object-p.md) · [`encode-json`](encode-json.md) · [Source](../../../json/core.lisp#L38) · [Index](../README.md)
