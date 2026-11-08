# `han.json:parse-json`

*Function · 函数*

## Syntax · 语法

```text
(han.json:parse-json string) → value
```

## Description · 说明

Parse one complete JSON value, allowing surrounding whitespace. Objects become `equal` hash tables with string keys, arrays become vectors and numbers become integers or, for decimal or exponent notation, double floats. The literals `true`, `false` and `null` map to `t`, `nil` and `:null`. Malformed input, trailing content and a non-string argument signal `json-error`. A syntactically valid number outside the floating-point range can also signal an arithmetic condition.

解析一个完整的 JSON 值，首尾可以有空白。对象变为以字符串为键的 `equal` 哈希表，数组变为向量，数值变为整数或双精度浮点数（含小数点或指数时）。`true`、`false`、`null` 分别变为 `t`、`nil`、`:null`。非法语法、尾随其他内容或参数不是字符串时，都会触发 `json-error`。语法正确、但超出浮点数表示范围的数值也可能触发算术条件。

## Examples · 示例

Read a heterogeneous array as Lisp scalar values.

把含有多种类型的数组解析成 Lisp 值。

```lisp
(coerce (han.json:parse-json "[2,true,false,null]") 'list)
;; => (2 T NIL :NULL)
```

An exponent in the input selects a double-float result.

含指数记法的数值解析为双精度浮点数。

```lisp
(han.json:parse-json "1.25e2")
;; => 125.0d0
```

Decode Unicode escape sequences in a quoted JSON string.

解码 JSON 字符串里的 Unicode 转义序列。

```lisp
(han.json:parse-json "\"\\u4F60\\u597D\"")
;; => "你好"
```

Reject two top-level values in one document.

一份文档包含两个顶层值时会报错。

```lisp
(han.json:parse-json "true false")
;; signals han.json:json-error
```

[`parse-json-file`](parse-json-file.md) · [`encode-json`](encode-json.md) · [`json-error`](json-error.md) · [Source · 源码](../../../json/core.lisp#L371) · [Index · 索引](../README.md)
