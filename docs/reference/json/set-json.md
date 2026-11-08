# `han.json:set-json`

*Function · 函数*

## Syntax · 语法

```text
(han.json:set-json object key value) → value
```

## Description · 说明

Store `value` under the string `key` in the given hash table, replacing any previous entry, and return the assigned value. Other references to the table see the update. A non-object or a non-string key signals `json-error`.

在给定哈希表中把字符串键 `key` 对应的条目设置为 `value`，并返回赋入的值。已有条目会被替换，指向同一张表的其他引用也能看到更新。传入非对象或非字符串键会触发 `json-error`。

## Examples · 示例

Updating an existing field changes the object and returns the new value.

更新已有字段会改变对象，并返回刚写入的值。

```lisp
(let ((config (han.json:json-object (cons "limit" 2))))
  (list (han.json:set-json config "limit" 5)
        (multiple-value-list (han.json:get-json config "limit"))))
;; => (5 (5 T))
```

Adding a field whose value is nil still marks it present.

新加字段即使值是 nil，也会被标记为存在。

```lisp
(let ((config (han.json:json-object)))
  (han.json:set-json config "trace" nil)
  (han.json:get-json config "trace"))
;; => values (NIL T)
```

Assigning a named field requires an object.

只有对象可以按键赋值。

```lisp
(han.json:set-json (han.json:json-array) "trace" t)
;; signals han.json:json-error
```

[`get-json`](get-json.md) · [`make-json-object`](make-json-object.md) · [Source · 源码](../../../json/core.lisp#L63) · [Index · 索引](../README.md)
