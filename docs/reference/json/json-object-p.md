# `han.json:json-object-p`

*Function · 函数*

## Syntax · 语法

```text
(han.json:json-object-p value) → boolean
```

## Description · 说明

Test whether `value` is a hash table. Every object constructed or parsed by Han satisfies this predicate. A hash table built by other code also satisfies it, even if it contains keys or values unsuitable for JSON.

判断 `value` 是否为哈希表。Han 构造或解析出的 JSON 对象都满足这个谓词。其他代码创建的哈希表也会返回真，即使里面的键或值无法编码为 JSON。

## Examples · 示例

Decide whether a decoded document has object fields.

判断解码后的文档能否按对象字段访问。

```lisp
(list (han.json:json-object-p (han.json:parse-json "{}"))
      (han.json:json-object-p (han.json:parse-json "[]")))
;; => (T NIL)
```

A Lisp hash table passes the container check even before its keys have been validated.

Lisp 哈希表能通过容器检查，里面的键还需单独验证。

```lisp
(let ((table (make-hash-table)))
  (setf (gethash 7 table) "seven")
  (han.json:json-object-p table))
;; => T
```

[`make-json-object`](make-json-object.md) · [`json-array-p`](json-array-p.md) · [Source · 源码](../../../json/core.lisp#L28) · [Index · 索引](../README.md)
