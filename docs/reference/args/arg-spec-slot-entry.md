# `han.args:arg-spec-slot-entry`

[简体中文](arg-spec-slot-entry.zh-CN.md)

*Accessor*

## Syntax

```text
(han.args:arg-spec-slot-entry spec) → string or nil
(setf (han.args:arg-spec-slot-entry spec) new-value) → new-value
```

## Description

Return a block's switch spelling, including `@` and the final `:`. The shorthand `(@:)filter` declares `@filter:`. Ordinary options have `nil` here.

## Examples

Expand a slot shorthand from its lookup name.

```lisp
(let ((spec (han.args:parse-arg-spec "(@:)filter")))
  (han.args:arg-spec-slot-entry spec))
;; => "@filter:"
```

Keep a public slot spelling independent of the lookup name.

```lisp
(let ((spec
        (han.args:parse-arg-spec "(@next:)filter")))
  (values (han.args:arg-spec-name spec) (han.args:arg-spec-slot-entry spec)))
;; => values ("filter" "@next:")
```

[`han.args:arg-spec`](arg-spec.md) · [`han.args:parse-arg-spec`](parse-arg-spec.md) · [Source](../../../args/spec.lisp) · [Index](../README.md)
