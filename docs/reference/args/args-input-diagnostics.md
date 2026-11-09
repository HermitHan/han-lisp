# `han.args:args-input-diagnostics`

[简体中文](args-input-diagnostics.zh-CN.md)

*Accessor*

## Syntax

```text
(han.args:args-input-diagnostics input) → list of arg-diagnostic
(setf (han.args:args-input-diagnostics input) new-value) → new-value
```

## Description

Return diagnostics from tokenization. A spelling such as a standalone `--` is retained as a value and also reported here. Binding carries these diagnostics into the result.

## Examples

Inspect the lexer warning on a bare double dash.

```lisp
(let ((input (han.args:parse-args-input '("demo" "--"))))
  (mapcar #'han.args:arg-diagnostic-kind (han.args:args-input-diagnostics input)))
;; => (:warning)
```

A syntactically valid option can still be undeclared at binding time.

```lisp
(let ((input
        (han.args:parse-args-input '("demo" "--unknown"))))
  (let ((result (han.args:bind-args (han.args:parse-args-spec nil) input)))
    (values (han.args:args-input-diagnostics input)
            (mapcar #'han.args:arg-diagnostic-code
                    (han.args:args-result-diagnostics result)))))
;; => values (nil (:undefined-option))
```

[`han.args:args-input`](args-input.md) · [`han.args:parse-args-input`](parse-args-input.md) · [Source](../../../args/lexer.lisp) · [Index](../README.md)
