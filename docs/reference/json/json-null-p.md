# `han.json:json-null-p`

[简体中文](json-null-p.zh-CN.md)

*Function*

## Syntax

```text
(han.json:json-null-p value) → boolean
```

## Description

Test whether the Lisp value is the keyword `:null`, the value produced by parsing JSON `null`. JSON `false` parses as `nil`. To distinguish a missing field from either value, inspect the presence flag returned by `get-json`.

## Examples

Classify the three scalar values in a JSON array.

```lisp
(mapcar #'han.json:json-null-p
        (coerce (han.json:parse-json "[null,false,0]") 'list))
;; => (T NIL NIL)
```

Use the presence flag as well when a configuration can omit a field.

```lisp
(let ((record (han.json:parse-json "{\"end\":null}")))
  (flet ((classify (key)
           (multiple-value-bind (value present-p) (han.json:get-json record key)
             (cond ((not present-p) :absent)
                   ((han.json:json-null-p value) :unset)
                   (t :configured)))))
    (list (classify "end") (classify "start"))))
;; => (:UNSET :ABSENT)
```

[`get-json`](get-json.md) · [`parse-json`](parse-json.md) · [Source](../../../json/core.lisp#L35) · [Index](../README.md)
