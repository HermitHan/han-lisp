# `han.args:arg-spec-long-entry`

[简体中文](arg-spec-long-entry.zh-CN.md)

*Accessor*

## Syntax

```text
(han.args:arg-spec-long-entry spec) → string or nil
(setf (han.args:arg-spec-long-entry spec) new-value) → new-value
```

## Description

Return the long option spelling, including its leading `--`. A shorthand `--` in the declaration expands to the full argument name. A declaration with no long spelling leaves this field `nil`.

## Examples

Inspect an automatically expanded long spelling.

```lisp
(let ((spec (han.args:parse-arg-spec "!(--/-j)jobs")))
  (han.args:arg-spec-long-entry spec))
;; => "--jobs"
```

Detect whether a short-only declaration has a long spelling.

```lisp
(han.args:arg-spec-long-entry (han.args:parse-arg-spec "(-j)jobs"))
;; => nil
```

[`han.args:arg-spec`](arg-spec.md) · [`han.args:parse-arg-spec`](parse-arg-spec.md) · [Source](../../../args/spec.lisp) · [Index](../README.md)
