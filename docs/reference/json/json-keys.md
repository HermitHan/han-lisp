# `han.json:json-keys`

*Function · 函数*

## Syntax · 语法

```text
(han.json:json-keys object) → keys
```

## Description · 说明

Return a sorted list of the object’s keys using `string<`. An empty object gives `nil`. Han objects have string keys and the writer uses this same ordering for serialization. Passing a non-object signals `json-error`.

返回按 `string<` 排序的键列表。空对象返回 `nil`。Han 对象使用字符串键，编码器也按此顺序输出。传入非对象会触发 `json-error`。

## Examples · 示例

List keys in the order used when encoding an object.

按编码对象时的顺序列出键。

```lisp
(han.json:json-keys (han.json:parse-json "{\"z\":1,\"a\":0}"))
;; => ("a" "z")
```

A document with no fields yields an empty key list.

空对象的键列表为空。

```lisp
(han.json:json-keys (han.json:json-object))
;; => NIL
```

An array must be traversed by index.

遍历数组时需要使用下标。

```lisp
(han.json:json-keys (han.json:json-array "Ada"))
;; signals han.json:json-error
```

[`json-object-p`](json-object-p.md) · [`encode-json`](encode-json.md) · [Source · 源码](../../../json/core.lisp#L38) · [Index · 索引](../README.md)
