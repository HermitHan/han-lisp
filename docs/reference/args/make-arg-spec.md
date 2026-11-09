# `han.args:make-arg-spec`

[简体中文](make-arg-spec.zh-CN.md)

*Constructor*

## Syntax

```text
(han.args:make-arg-spec &key name long-entry short-entry slot-entry (arity :single) required (visibility :public) default) → han.args:arg-spec
```

## Description

Construct and return a fresh `arg-spec` with the supplied keyword fields. The default arity is `:single` and visibility is `:public`. The other constructor keywords default to `nil`. Use `parse-arg-spec` to expand shorthand spellings and validate a declaration string.

## Examples

Set both spellings for one required option.

```lisp
(let ((spec
        (han.args:make-arg-spec
         :name "jobs" :long-entry "--jobs" :short-entry "-j" :required t)))
  (han.args:arg-spec-arity spec))
;; => :single
```

Bind a custom long option assembled in Lisp.

```lisp
(let* ((field (han.args:make-arg-spec :name "chatty" :long-entry "--verbose" :arity :flag))
       (schema (han.args:parse-args-spec (list field)))
       (result (han.args:bind-args schema (han.args:parse-args-input '("demo" "--verbose")))))
  (han.args:get-arg field result))
;; => values (t :input)
```

[`han.args:arg-spec`](arg-spec.md) · [`han.args:arg-spec-arity`](arg-spec-arity.md) · [`han.args:parse-arg-spec`](parse-arg-spec.md) · [Source](../../../args/spec.lisp) · [Index](../README.md)
