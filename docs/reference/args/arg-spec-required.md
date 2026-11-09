# `han.args:arg-spec-required`

[简体中文](arg-spec-required.zh-CN.md)

*Accessor*

## Syntax

```text
(han.args:arg-spec-required spec) → generalized boolean
(setf (han.args:arg-spec-required spec) new-value) → new-value
```

## Description

Return whether the declaration requires a value. During binding an unsatisfied required argument produces a diagnostic. Parsing `!` sets this flag for a single-value option, and flag declarations are always optional.

## Examples

Inspect a single-value option declared with an exclamation mark.

```lisp
(let ((spec (han.args:parse-arg-spec "!(--/-j)jobs")))
  (han.args:arg-spec-required spec))
;; => t
```

A positional declaration is required, while a flag is optional.

```lisp
(mapcar (lambda (decl)
          (han.args:arg-spec-required (han.args:parse-arg-spec decl)))
        '("$1" "!(--/-v)verbose?"))
;; => (t nil)
```

[`han.args:arg-spec`](arg-spec.md) · [`han.args:parse-arg-spec`](parse-arg-spec.md) · [Source](../../../args/spec.lisp) · [Index](../README.md)
