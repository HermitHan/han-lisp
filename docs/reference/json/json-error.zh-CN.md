# `han.json:json-error`

[English](json-error.md)

*条件类型*

## 语法

```text
han.json:json-error  <:  error
```

## 说明

解析畸形 JSON、用非法键值对构造对象，或编码 Han 无法表示的 Lisp 值时，可捕获此条件。打印条件会得到诊断信息。文件错误与浮点运算条件保留自身的条件类型。

## 示例

在应用读取数组时捕获语法错误。

```lisp
(handler-case (han.json:parse-json "[1,]")
  (han.json:json-error () :invalid-json))
;; => :INVALID-JSON
```

记录中带有分数时，编码器也会发出这个条件。

```lisp
(han.json:encode-json (han.json:json-object (cons "rate" 1/3)))
;; signals han.json:json-error
```

[`parse-json`](parse-json.zh-CN.md) · [`encode-json`](encode-json.zh-CN.md) · [源码](../../../json/core.lisp#L3) · [索引](../README.zh-CN.md)
