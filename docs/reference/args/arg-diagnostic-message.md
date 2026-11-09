# `han.args:arg-diagnostic-message`

[简体中文](arg-diagnostic-message.zh-CN.md)

*Accessor*

## Syntax

```text
(han.args:arg-diagnostic-message diagnostic) → string
(setf (han.args:arg-diagnostic-message diagnostic) new-value) → new-value
```

## Description

Return the diagnostic's human-readable explanation. For branching on a particular failure, use the code when one is available.

## Examples

Read the explanation for a suspicious double dash.

```lisp
(let ((diagnostic
        (first (han.args:args-input-diagnostics
                (han.args:parse-args-input '("demo" "--"))))))
  (han.args:arg-diagnostic-message diagnostic))
;; => "Only --, no name, missed?"
```

Display an explanation for a missing required output.

```lisp
(let ((result
        (han.args:bind-args
         (han.args:parse-args-spec
          (mapcar #'han.args:parse-arg-spec '("!(--)output")))
         (han.args:parse-args-input '("demo")))))
  (han.args:arg-diagnostic-message
   (first (han.args:args-result-diagnostics result))))
;; => "Required argument output is missing."
```

[`han.args:arg-diagnostic`](arg-diagnostic.md) · [`han.args:args-result-diagnostics`](args-result-diagnostics.md) · [Source](../../../args/lexer.lisp) · [Index](../README.md)
