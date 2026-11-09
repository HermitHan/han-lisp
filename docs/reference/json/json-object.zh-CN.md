# `han.json:json-object`

[English](json-object.md)

*函数*

## 语法

```text
(han.json:json-object &rest pairs) → object
```

## 说明

将逐个传入的 `(cons key value)` 键值对构造成使用 `equal` 的新哈希表。键为区分大小写的字符串，重复键取最后一个值。键不是字符串时触发 `json-error`。已经持有键值对列表时，可直接传给 `make-json-object`。

## 示例

用两组字段构造记录并列举键。

```lisp
(let ((record (han.json:json-object (cons "name" "Ada") (cons "ok" t))))
  (han.json:json-keys record))
;; => ("name" "ok")
```

把完整向量作为一个字段的值，再取出向量的首元素。

```lisp
(let ((record (han.json:json-object
               (cons "args" (han.json:json-array "--limit" "2")))))
  (aref (han.json:get-json record "args") 0))
;; => "--limit"
```

[`make-json-object`](make-json-object.zh-CN.md) · [`get-json`](get-json.zh-CN.md) · [源码](../../../json/core.lisp#L20) · [索引](../README.zh-CN.md)
