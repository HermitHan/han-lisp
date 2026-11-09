# `han.args:arg-spec-short-entry`

[简体中文](arg-spec-short-entry.zh-CN.md)

*Accessor*

## Syntax

```text
(han.args:arg-spec-short-entry spec) → string or nil
(setf (han.args:arg-spec-short-entry spec) new-value) → new-value
```

## Description

Return the declared short option, including its leading dash. This spelling can be used to supply the same binding as the long option. It is `nil` when omitted.

## Examples

Read an explicitly declared short spelling.

```lisp
(let ((spec (han.args:parse-arg-spec "!(--/-j)jobs")))
  (han.args:arg-spec-short-entry spec))
;; => "-j"
```

Derive the short option from the first letter of its name.

```lisp
(han.args:arg-spec-short-entry (han.args:parse-arg-spec "(-)threads"))
;; => "-t"
```

[`han.args:arg-spec`](arg-spec.md) · [`han.args:parse-arg-spec`](parse-arg-spec.md) · [Source](../../../args/spec.lisp) · [Index](../README.md)
