# `han.args:arg-diagnostic-kind`

[简体中文](arg-diagnostic-kind.zh-CN.md)

*Accessor*

## Syntax

```text
(han.args:arg-diagnostic-kind diagnostic) → keyword
(setf (han.args:arg-diagnostic-kind diagnostic) new-value) → new-value
```

## Description

Return the severity, `:warning` or `:error`, of this diagnostic. Filter by kind when deciding whether the command can proceed.

## Examples

Recognize a warning about a suspicious token.

```lisp
(let ((diagnostic
        (first (han.args:args-input-diagnostics
                (han.args:parse-args-input '("demo" "--"))))))
  (han.args:arg-diagnostic-kind diagnostic))
;; => :warning
```

Inspect the severity of an omitted required argument.

```lisp
(let ((result
        (han.args:bind-args
         (han.args:parse-args-spec
          (mapcar #'han.args:parse-arg-spec '("!(--)output")))
         (han.args:parse-args-input '("demo")))))
  (mapcar #'han.args:arg-diagnostic-kind
          (han.args:args-result-diagnostics result)))
;; => (:error)
```

[`han.args:arg-diagnostic`](arg-diagnostic.md) · [`han.args:args-result-diagnostics`](args-result-diagnostics.md) · [Source](../../../args/lexer.lisp) · [Index](../README.md)
