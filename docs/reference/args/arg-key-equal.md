# `han.args:arg-key-equal`

[简体中文](arg-key-equal.zh-CN.md)

*Function*

## Syntax

```text
(han.args:arg-key-equal x y) → generalized-boolean
```

## Description

Compare two string keys case-insensitively with `string-equal`. For other pairs use `eql`. This supports named arguments and positional integers while preserving the distinction between the integer `1` and the string `"1"`.

## Examples

Compare names and numeric positions directly.

```lisp
(list (han.args:arg-key-equal "Jobs" "jobs")
      (han.args:arg-key-equal 1 1)
      (han.args:arg-key-equal 1 "1"))
;; => (t t nil)
```

Use the same comparison when searching a mixture of names and positions.

```lisp
(list (position "NAME" '(0 "name" "file") :test #'han.args:arg-key-equal)
      (position "0" '(0 "name" "file") :test #'han.args:arg-key-equal))
;; => (1 nil)
```

[`han.args:arg-spec-name`](arg-spec-name.md) · [`han.args:parse-args-spec`](parse-args-spec.md) · [Source](../../../args/spec.lisp) · [Index](../README.md)
