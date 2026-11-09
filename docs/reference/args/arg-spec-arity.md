# `han.args:arg-spec-arity`

[简体中文](arg-spec-arity.zh-CN.md)

*Accessor*

## Syntax

```text
(han.args:arg-spec-arity spec) → keyword
(setf (han.args:arg-spec-arity spec) new-value) → new-value
```

## Description

Return the binding mode. `:single` consumes a value, `:flag` records presence, `:block` captures a list of tokens, and `:position` selects a free positional value.

## Examples

Recognize an option that consumes one value.

```lisp
(let ((spec (han.args:parse-arg-spec "!(--/-j)jobs")))
  (han.args:arg-spec-arity spec))
;; => :single
```

Dispatch help rendering by the declared binding mode.

```lisp
(mapcar (lambda (decl)
          (han.args:arg-spec-arity (han.args:parse-arg-spec decl)))
        '("(--)name" "(--/-v)verbose?" "(@:)files" "$1"))
;; => (:single :flag :block :position)
```

[`han.args:arg-spec`](arg-spec.md) · [`han.args:parse-arg-spec`](parse-arg-spec.md) · [Source](../../../args/spec.lisp) · [Index](../README.md)
