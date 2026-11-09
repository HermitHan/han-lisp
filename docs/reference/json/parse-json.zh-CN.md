# `han.json:parse-json`

[English](parse-json.md)

*函数*

## 语法

```text
(han.json:parse-json string) → value
```

## 说明

解析一个完整的 JSON 值，首尾可以有空白。对象变为以字符串为键的 `equal` 哈希表，数组变为向量，数值变为整数或双精度浮点数（含小数点或指数时）。`true`、`false`、`null` 分别变为 `t`、`nil`、`:null`。非法语法、尾随其他内容或参数不是字符串时，都会触发 `json-error`。成对的代理码转义解码为单个字符；单独的代理码或宿主无法映射的字符会触发 `json-error`。小数可能发生舍入；语法正确但超出浮点数表示范围的数值可能触发算术条件。

## 示例

把含有多种类型的数组解析成 Lisp 值。

```lisp
(coerce (han.json:parse-json "[2,true,false,null]") 'list)
;; => (2 T NIL :NULL)
```

含指数记法的数值解析为双精度浮点数。

```lisp
(han.json:parse-json "1.25e2")
;; => 125.0d0
```

解码 JSON 字符串里的 Unicode 转义序列。

```lisp
(han.json:parse-json "\"\\u4F60\\u597D\"")
;; => "你好"
```

一份文档包含两个顶层值时会报错。

```lisp
(han.json:parse-json "true false")
;; signals han.json:json-error
```

[`parse-json-file`](parse-json-file.zh-CN.md) · [`encode-json`](encode-json.zh-CN.md) · [`json-error`](json-error.zh-CN.md) · [源码](../../../json/core.lisp#L357) · [索引](../README.zh-CN.md)
