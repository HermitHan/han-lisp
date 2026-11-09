# `han.json:get-json`

[简体中文](get-json.zh-CN.md)

*Function*

## Syntax

```text
(han.json:get-json object key &optional default) → value, present-p
```

## Description

Read one field from a string-keyed object. A hit returns the stored value and `t`, even when the value is `nil` or `:null`. A missing key or a non-object returns `default` (initially `nil`) and `nil`. On a hash table a non-string key signals `json-error`.

## Examples

Compare an explicit false setting with an omitted field that has a fallback.

```lisp
(let ((config (han.json:parse-json "{\"retry\":false}")))
  (list (multiple-value-list (han.json:get-json config "retry" :unset))
        (multiple-value-list (han.json:get-json config "limit" :unset))))
;; => ((NIL T) (:UNSET NIL))
```

An explicit JSON null keeps its own value even when a default was supplied.

```lisp
(han.json:get-json (han.json:parse-json "{\"timeout\":null}") "timeout" 30)
;; => values (:NULL T)
```

A nested record can itself be absent. Querying that missing record returns the caller’s default and a false presence flag.

```lisp
(let ((record (han.json:json-object)))
  (han.json:get-json (han.json:get-json record "settings") "retry" 3))
;; => values (3 NIL)
```

Use a string when looking up an object key. An integer index is for vectors.

```lisp
(han.json:get-json (han.json:json-object) 0)
;; signals han.json:json-error
```

[`set-json`](set-json.md) · [`json-null-p`](json-null-p.md) · [Source](../../../json/core.lisp#L49) · [Index](../README.md)
