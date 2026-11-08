# `han.json:json-error`

*Condition type · 条件类型*

## Syntax · 语法

```text
han.json:json-error  <:  error
```

## Description · 说明

Handle this condition when parsing malformed JSON, constructing an object from an invalid pair or encoding a Lisp value that Han cannot represent. The condition prints a diagnostic message. An operating-system error while opening a file remains a separate condition.

解析畸形 JSON、用非法键值对构造对象，或编码 Han 无法表示的 Lisp 值时，可捕获此条件。打印条件会得到诊断信息。打开文件时遇到的系统错误保留自身的条件类型。

## Examples · 示例

Handle a malformed array at the point where the application reads it.

在应用读取数组时捕获语法错误。

```lisp
(handler-case (han.json:parse-json "[1,]")
  (han.json:json-error () :invalid-json))
;; => :INVALID-JSON
```

The encoder signals the same condition when a record contains a ratio.

记录中带有分数时，编码器也会发出这个条件。

```lisp
(han.json:encode-json (han.json:json-object (cons "rate" 1/3)))
;; signals han.json:json-error
```

[`parse-json`](parse-json.md) · [`encode-json`](encode-json.md) · [Source · 源码](../../../json/core.lisp#L3) · [Index · 索引](../README.md)
