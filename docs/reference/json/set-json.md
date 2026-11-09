# `han.json:set-json`

[简体中文](set-json.zh-CN.md)

*Function*

## Syntax

```text
(han.json:set-json object key value) → value
```

## Description

Store `value` under the string `key` in the given hash table, replacing any previous entry, and return the assigned value. Other references to the table see the update. A non-object or a non-string key signals `json-error`.

## Examples

Updating an existing field changes the object and returns the new value.

```lisp
(let ((config (han.json:json-object (cons "limit" 2))))
  (list (han.json:set-json config "limit" 5)
        (multiple-value-list (han.json:get-json config "limit"))))
;; => (5 (5 T))
```

Adding a field whose value is nil still marks it present.

```lisp
(let ((config (han.json:json-object)))
  (han.json:set-json config "trace" nil)
  (han.json:get-json config "trace"))
;; => values (NIL T)
```

Assigning a named field requires an object.

```lisp
(han.json:set-json (han.json:json-array) "trace" t)
;; signals han.json:json-error
```

[`get-json`](get-json.md) · [`make-json-object`](make-json-object.md) · [Source](../../../json/core.lisp#L63) · [Index](../README.md)
