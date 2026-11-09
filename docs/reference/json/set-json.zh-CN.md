# `han.json:set-json`

[English](set-json.md)

*函数*

## 语法

```text
(han.json:set-json object key value) → value
```

## 说明

在给定哈希表中把字符串键 `key` 对应的条目设置为 `value`，并返回赋入的值。已有条目会被替换，指向同一张表的其他引用也能看到更新。传入非对象或非字符串键会触发 `json-error`。

## 示例

更新已有字段会改变对象，并返回刚写入的值。

```lisp
(let ((config (han.json:json-object (cons "limit" 2))))
  (list (han.json:set-json config "limit" 5)
        (multiple-value-list (han.json:get-json config "limit"))))
;; => (5 (5 T))
```

新加字段即使值是 nil，也会被标记为存在。

```lisp
(let ((config (han.json:json-object)))
  (han.json:set-json config "trace" nil)
  (han.json:get-json config "trace"))
;; => values (NIL T)
```

只有对象可以按键赋值。

```lisp
(han.json:set-json (han.json:json-array) "trace" t)
;; signals han.json:json-error
```

[`get-json`](get-json.zh-CN.md) · [`make-json-object`](make-json-object.zh-CN.md) · [源码](../../../json/core.lisp#L63) · [索引](../README.zh-CN.md)
