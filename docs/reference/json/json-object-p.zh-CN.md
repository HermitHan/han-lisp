# `han.json:json-object-p`

[English](json-object-p.md)

*函数*

## 语法

```text
(han.json:json-object-p value) → boolean
```

## 说明

判断 `value` 是否为哈希表。Han 构造或解析出的 JSON 对象都满足这个谓词。其他代码创建的哈希表也会返回真，即使里面的键或值无法编码为 JSON。

## 示例

判断解码后的文档能否按对象字段访问。

```lisp
(list (han.json:json-object-p (han.json:parse-json "{}"))
      (han.json:json-object-p (han.json:parse-json "[]")))
;; => (T NIL)
```

Lisp 哈希表能通过容器检查，里面的键还需单独验证。

```lisp
(let ((table (make-hash-table)))
  (setf (gethash 7 table) "seven")
  (han.json:json-object-p table))
;; => T
```

[`make-json-object`](make-json-object.zh-CN.md) · [`json-array-p`](json-array-p.zh-CN.md) · [源码](../../../json/core.lisp#L28) · [索引](../README.zh-CN.md)
