# `han.json:get-json`

*Function · 函数*

## Syntax · 语法

```text
(han.json:get-json object key &optional default) → value, present-p
```

## Description · 说明

Read one field from a string-keyed object. A hit returns the stored value and `t`, even when the value is `nil` or `:null`. A missing key or a non-object returns `default` (initially `nil`) and `nil`. On a hash table a non-string key signals `json-error`.

按字符串键读取对象的一层字段。命中时返回存入的值与 `t`，值本身可以是 `nil` 或 `:null`。键不存在或输入不是对象时返回 `default`（缺省为 `nil`）与 `nil`。对哈希表传入非字符串键会触发 `json-error`。

## Examples · 示例

Compare an explicit false setting with an omitted field that has a fallback.

比较显式关闭的设置和使用备用值的缺失字段。

```lisp
(let ((config (han.json:parse-json "{\"retry\":false}")))
  (list (multiple-value-list (han.json:get-json config "retry" :unset))
        (multiple-value-list (han.json:get-json config "limit" :unset))))
;; => ((NIL T) (:UNSET NIL))
```

An explicit JSON null keeps its own value even when a default was supplied.

即使指定了默认值，显式 JSON 空值仍保留自己的值。

```lisp
(han.json:get-json (han.json:parse-json "{\"timeout\":null}") "timeout" 30)
;; => values (:NULL T)
```

A nested record can itself be absent. Querying that missing record returns the caller’s default and a false presence flag.

嵌套对象本身也可能缺失。继续查询时会返回调用方的默认值，存在标志为假。

```lisp
(let ((record (han.json:json-object)))
  (han.json:get-json (han.json:get-json record "settings") "retry" 3))
;; => values (3 NIL)
```

Use a string when looking up an object key. An integer index is for vectors.

对象查询用字符串键，整数下标用于向量。

```lisp
(han.json:get-json (han.json:json-object) 0)
;; signals han.json:json-error
```

[`set-json`](set-json.md) · [`json-null-p`](json-null-p.md) · [Source · 源码](../../../json/core.lisp#L49) · [Index · 索引](../README.md)
