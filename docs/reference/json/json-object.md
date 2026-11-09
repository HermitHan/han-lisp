# `han.json:json-object`

[简体中文](json-object.zh-CN.md)

*Function*

## Syntax

```text
(han.json:json-object &rest pairs) → object
```

## Description

Build a fresh `equal` hash table from separate `(cons key value)` arguments. Keys are case-sensitive strings and the last pair for a key wins. A pair with a non-string key signals `json-error`. Use `make-json-object` when a list of pairs is already available.

## Examples

Build a record from two field pairs and list its keys.

```lisp
(let ((record (han.json:json-object (cons "name" "Ada") (cons "ok" t))))
  (han.json:json-keys record))
;; => ("name" "ok")
```

Store a whole vector in the cdr of one field pair and read back its first element.

```lisp
(let ((record (han.json:json-object
               (cons "args" (han.json:json-array "--limit" "2")))))
  (aref (han.json:get-json record "args") 0))
;; => "--limit"
```

[`make-json-object`](make-json-object.md) · [`get-json`](get-json.md) · [Source](../../../json/core.lisp#L20) · [Index](../README.md)
