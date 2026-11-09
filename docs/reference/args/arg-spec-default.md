# `han.args:arg-spec-default`

[简体中文](arg-spec-default.zh-CN.md)

*Accessor*

## Syntax

```text
(han.args:arg-spec-default spec) → string, expression or nil
(setf (han.args:arg-spec-default spec) new-value) → new-value
```

## Description

Return the parsed default before reference evaluation. Literal defaults are strings, a reference is a `(:query name)` form, and text with embedded references is a `(:concat ...)` form. `get-arg` resolves these forms on lookup.

## Examples

Inspect a default before resolving an interpolated name.

```lisp
(let ((spec (han.args:parse-arg-spec "log=@{name}.log")))
  (han.args:arg-spec-default spec))
;; => (:concat (:query "name") ".log")
```

Distinguish a literal default from a query and an absent default.

```lisp
(mapcar (lambda (decl)
          (han.args:arg-spec-default (han.args:parse-arg-spec decl)))
        '("a=4" "b=@a" "c"))
;; => ("4" (:query "a") nil)
```

[`han.args:arg-spec`](arg-spec.md) · [`han.args:parse-arg-spec`](parse-arg-spec.md) · [Source](../../../args/spec.lisp) · [Index](../README.md)
