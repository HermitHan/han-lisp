# `han.args:arg-spec-visibility`

[简体中文](arg-spec-visibility.zh-CN.md)

*Accessor*

## Syntax

```text
(han.args:arg-spec-visibility spec) → keyword
(setf (han.args:arg-spec-visibility spec) new-value) → new-value
```

## Description

Return `:public` or `:hidden`. A `%` prefix marks a declaration as hidden. Help generators can read this metadata when choosing which arguments to display.

## Examples

Read the visibility of a hidden setting.

```lisp
(let ((spec (han.args:parse-arg-spec "%mode=brief")))
  (han.args:arg-spec-visibility spec))
;; => :hidden
```

Choose declarations for public help.

```lisp
(mapcar #'han.args:arg-spec-name
        (remove-if-not
         (lambda (decl) (eq (han.args:arg-spec-visibility decl) :public))
         (mapcar #'han.args:parse-arg-spec '("(--)name" "%mode=quiet"))))
;; => ("name")
```

[`han.args:arg-spec`](arg-spec.md) · [`han.args:parse-arg-spec`](parse-arg-spec.md) · [Source](../../../args/spec.lisp) · [Index](../README.md)
