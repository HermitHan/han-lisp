# `han.args:args-spec-args-table`

[简体中文](args-spec-args-table.zh-CN.md)

*Accessor*

## Syntax

```text
(han.args:args-spec-args-table specs) → hash table
(setf (han.args:args-spec-args-table specs) new-value) → new-value
```

## Description

Return the table of declarations keyed by lookup name. `parse-args-spec` builds an `equalp` table, so a string key can be queried with different letter case. Values are `arg-spec` records.

## Examples

Find a declaration with differently cased input.

```lisp
(let ((specs
        (han.args:parse-args-spec
         (list (han.args:parse-arg-spec "(--/-j)jobs=1")) "report")))
  (han.args:arg-spec-long-entry (gethash "JOBS" (han.args:args-spec-args-table specs))))
;; => "--jobs"
```

Read positional declarations by integer key.

```lisp
(let ((specs
        (han.args:parse-args-spec
         (mapcar #'han.args:parse-arg-spec '("$1" "(--)mode")))))
  (han.args:arg-spec-arity (gethash 1 (han.args:args-spec-args-table specs))))
;; => :position
```

[`han.args:args-spec`](args-spec.md) · [`han.args:parse-args-spec`](parse-args-spec.md) · [Source](../../../args/spec.lisp) · [Index](../README.md)
