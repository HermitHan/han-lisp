# `han.json:json-object-p`

[简体中文](json-object-p.zh-CN.md)

*Function*

## Syntax

```text
(han.json:json-object-p value) → boolean
```

## Description

Test whether `value` is a hash table. Every object constructed or parsed by Han satisfies this predicate. A hash table built by other code also satisfies it, even if it contains keys or values unsuitable for JSON.

## Examples

Decide whether a decoded document has object fields.

```lisp
(list (han.json:json-object-p (han.json:parse-json "{}"))
      (han.json:json-object-p (han.json:parse-json "[]")))
;; => (T NIL)
```

A Lisp hash table passes the container check even before its keys have been validated.

```lisp
(let ((table (make-hash-table)))
  (setf (gethash 7 table) "seven")
  (han.json:json-object-p table))
;; => T
```

[`make-json-object`](make-json-object.md) · [`json-array-p`](json-array-p.md) · [Source](../../../json/core.lisp#L28) · [Index](../README.md)
