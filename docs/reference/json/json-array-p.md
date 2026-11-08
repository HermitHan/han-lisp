# `han.json:json-array-p`

*Function · 函数*

## Syntax · 语法

```text
(han.json:json-array-p value) → boolean
```

## Description · 说明

Recognize a vector whose type is not a string. The predicate checks the container type, including the empty vector, without examining elements. Use `length` and `aref` to access a parsed array.

检查 `value` 是否为字符串以外的向量。空向量也算数组，此谓词只检查容器类型。可用 `length` 取解析所得数组的长度，用 `aref` 按下标取元素。

## Examples · 示例

Recognize the empty JSON array among other Lisp sequences.

在多种 Lisp 序列中识别空 JSON 数组。

```lisp
(mapcar #'han.json:json-array-p
        (list (han.json:parse-json "[]") "abc" '(1 2)))
;; => (T NIL NIL)
```

A specialized numeric vector can also supply array elements to the encoder.

专用数值向量也可以给编码器提供数组元素。

```lisp
(let ((bits #*101))
  (list (han.json:json-array-p bits)
        (han.json:encode-json bits :indent nil)))
;; => (T "[1,0,1]")
```

[`json-array`](json-array.md) · [`json-object-p`](json-object-p.md) · [Source · 源码](../../../json/core.lisp#L31) · [Index · 索引](../README.md)
