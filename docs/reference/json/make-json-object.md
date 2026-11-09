# `han.json:make-json-object`

[简体中文](make-json-object.zh-CN.md)

*Function*

## Syntax

```text
(han.json:make-json-object &optional pairs) → object
```

## Description

Build a fresh `equal` hash table from a list of conses. Each `car` must be a string and each `cdr` is stored as the complete value. Duplicate keys take their last value. An invalid pair signals `json-error`. Omitting the list gives an empty object.

## Examples

Build an object from a field list that assigns the same key twice.

```lisp
(let* ((fields '(("limit" . 5) ("limit" . 8)))
       (config (han.json:make-json-object fields)))
  (multiple-value-list (han.json:get-json config "limit")))
;; => (8 T)
```

With no fields, the constructor provides an empty object suitable for encoding.

```lisp
(han.json:encode-json (han.json:make-json-object) :indent nil)
;; => "{}"
```

Reject a field list whose key is a keyword symbol.

```lisp
(han.json:make-json-object '((:limit . 5)))
;; signals han.json:json-error
```

[`json-object`](json-object.md) · [`set-json`](set-json.md) · [Source](../../../json/core.lisp#L12) · [Index](../README.md)
