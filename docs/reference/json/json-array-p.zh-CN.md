# `han.json:json-array-p`

[English](json-array-p.md)

*函数*

## 语法

```text
(han.json:json-array-p value) → boolean
```

## 说明

检查 `value` 是否为字符串以外的向量。空向量也算数组，此谓词只检查容器类型。可用 `length` 取解析所得数组的长度，用 `aref` 按下标取元素。

## 示例

在多种 Lisp 序列中识别空 JSON 数组。

```lisp
(mapcar #'han.json:json-array-p
        (list (han.json:parse-json "[]") "abc" '(1 2)))
;; => (T NIL NIL)
```

专用数值向量也可以给编码器提供数组元素。

```lisp
(let ((bits #*101))
  (list (han.json:json-array-p bits)
        (han.json:encode-json bits :indent nil)))
;; => (T "[1,0,1]")
```

[`json-array`](json-array.zh-CN.md) · [`json-object-p`](json-object-p.zh-CN.md) · [源码](../../../json/core.lisp#L31) · [索引](../README.zh-CN.md)
