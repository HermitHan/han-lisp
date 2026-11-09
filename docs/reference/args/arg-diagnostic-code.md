# `han.args:arg-diagnostic-code`

[简体中文](arg-diagnostic-code.zh-CN.md)

*Accessor*

## Syntax

```text
(han.args:arg-diagnostic-code diagnostic) → keyword or nil
(setf (han.args:arg-diagnostic-code diagnostic) new-value) → new-value
```

## Description

Return the machine-readable identifier when supplied. The binder uses codes such as `:missing-required`, `:missing-option-value`, and `:conflict`. Lexer warnings currently leave this field `nil`.

## Examples

Branch on an absent required field.

```lisp
(let ((diagnostic
        (first
         (han.args:args-result-diagnostics
          (han.args:bind-args
           (han.args:parse-args-spec (list (han.args:parse-arg-spec "!(--)input")))
           (han.args:parse-args-input '("demo")))))))
  (han.args:arg-diagnostic-code diagnostic))
;; => :missing-required
```

Inspect a lexer warning without a machine-readable code.

```lisp
(let ((input
        (han.args:parse-args-input '("demo" "--"))))
  (let ((warning (first (han.args:args-input-diagnostics input))))
    (values (han.args:arg-diagnostic-kind warning)
            (han.args:arg-diagnostic-code warning))))
;; => values (:warning nil)
```

[`han.args:arg-diagnostic`](arg-diagnostic.md) · [`han.args:args-result-diagnostics`](args-result-diagnostics.md) · [Source](../../../args/lexer.lisp) · [Index](../README.md)
