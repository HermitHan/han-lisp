# `han.args:arg-spec-name`

[简体中文](arg-spec-name.zh-CN.md)

*Accessor*

## Syntax

```text
(han.args:arg-spec-name spec) → string or integer
(setf (han.args:arg-spec-name spec) new-value) → new-value
```

## Description

Return the key used to store and query this argument. Named arguments use strings, while a positional declaration such as `$2` uses the integer `2`.

## Examples

Retrieve the lookup key behind two option spellings.

```lisp
(let ((spec (han.args:parse-arg-spec "!(--/-j)jobs")))
  (han.args:arg-spec-name spec))
;; => "jobs"
```

Look up positional declarations using an integer key.

```lisp
(han.args:arg-spec-name (han.args:parse-arg-spec "$2"))
;; => 2
```

[`han.args:arg-spec`](arg-spec.md) · [`han.args:parse-arg-spec`](parse-arg-spec.md) · [Source](../../../args/spec.lisp) · [Index](../README.md)
