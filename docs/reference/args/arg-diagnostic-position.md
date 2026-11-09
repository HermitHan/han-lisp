# `han.args:arg-diagnostic-position`

[简体中文](arg-diagnostic-position.zh-CN.md)

*Accessor*

## Syntax

```text
(han.args:arg-diagnostic-position diagnostic) → nonnegative integer or nil
(setf (han.args:arg-diagnostic-position diagnostic) new-value) → new-value
```

## Description

Return the zero-based token index after the command name, if the diagnostic refers to an input token. A missing declaration value may have no input position.

## Examples

Locate a lexer warning in the original input.

```lisp
(let ((diagnostic
        (first (han.args:args-input-diagnostics
                (han.args:parse-args-input '("demo" "--"))))))
  (han.args:arg-diagnostic-position diagnostic))
;; => 0
```

Handle an absent argument with no corresponding token.

```lisp
(let ((result
        (han.args:bind-args
         (han.args:parse-args-spec
          (mapcar #'han.args:parse-arg-spec '("!(--)output")))
         (han.args:parse-args-input '("demo")))))
  (let ((d (first (han.args:args-result-diagnostics result))))
    (values (han.args:arg-diagnostic-code d)
            (han.args:arg-diagnostic-position d))))
;; => values (:missing-required nil)
```

[`han.args:arg-diagnostic`](arg-diagnostic.md) · [`han.args:args-result-diagnostics`](args-result-diagnostics.md) · [Source](../../../args/lexer.lisp) · [Index](../README.md)
