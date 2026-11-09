# `han.json:json-keys`

[English](json-keys.md)

*函数*

## 语法

```text
(han.json:json-keys object) → keys
```

## 说明

返回按 `string<` 排序的键列表。空对象返回 `nil`。Han 对象使用字符串键，编码器也按此顺序输出。传入非对象会触发 `json-error`。

## 示例

按编码对象时的顺序列出键。

```lisp
(han.json:json-keys (han.json:parse-json "{\"z\":1,\"a\":0}"))
;; => ("a" "z")
```

空对象的键列表为空。

```lisp
(han.json:json-keys (han.json:json-object))
;; => NIL
```

遍历数组时需要使用下标。

```lisp
(han.json:json-keys (han.json:json-array "Ada"))
;; signals han.json:json-error
```

[`json-object-p`](json-object-p.zh-CN.md) · [`encode-json`](encode-json.zh-CN.md) · [源码](../../../json/core.lisp#L38) · [索引](../README.zh-CN.md)
