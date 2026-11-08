# `han.json:json-object`

*Function · 函数*

## Syntax · 语法

```text
(han.json:json-object &rest pairs) → object
```

## Description · 说明

Build a fresh `equal` hash table from separate `(cons key value)` arguments. Keys are case-sensitive strings and the last pair for a key wins. A pair with a non-string key signals `json-error`. Use `make-json-object` when a list of pairs is already available.

将逐个传入的 `(cons key value)` 键值对构造成使用 `equal` 的新哈希表。键为区分大小写的字符串，重复键取最后一个值。键不是字符串时触发 `json-error`。已经持有键值对列表时，可直接传给 `make-json-object`。

## Examples · 示例

Build a record from two field pairs and list its keys.

用两组字段构造记录并列举键。

```lisp
(let ((record (han.json:json-object (cons "name" "Ada") (cons "ok" t))))
  (han.json:json-keys record))
;; => ("name" "ok")
```

Store a whole vector in the cdr of one field pair and read back its first element.

把完整向量作为一个字段的值，再取出向量的首元素。

```lisp
(let ((record (han.json:json-object
               (cons "args" (han.json:json-array "--limit" "2")))))
  (aref (han.json:get-json record "args") 0))
;; => "--limit"
```

[`make-json-object`](make-json-object.md) · [`get-json`](get-json.md) · [Source · 源码](../../../json/core.lisp#L20) · [Index · 索引](../README.md)
