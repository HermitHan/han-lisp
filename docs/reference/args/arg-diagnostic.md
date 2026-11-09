# `han.args:arg-diagnostic`

[简体中文](arg-diagnostic.zh-CN.md)

*Structure type*

## Syntax

```text
han.args:arg-diagnostic
(typep object 'han.args:arg-diagnostic) → generalized-boolean
```

## Description

A warning or error about input. Applications can inspect its severity, code, message, and optional location, then decide whether to continue.

## Examples

Check the record generated for a token spelling warning.

```lisp
(let ((diagnostic
        (first (han.args:args-input-diagnostics
                (han.args:parse-args-input '("demo" "--"))))))
  (typep diagnostic 'han.args:arg-diagnostic))
;; => t
```

Render a diagnostic alongside a caller-provided progress message.

```lisp
(let ((events (list "reading"
                    (han.args:make-arg-diagnostic :kind :warning :message "unknown option"))))
  (mapcar (lambda (event)
            (etypecase event
              (string event)
              (han.args:arg-diagnostic (han.args:arg-diagnostic-message event))))
          events))
;; => ("reading" "unknown option")
```

[`han.args:arg-diagnostic-p`](arg-diagnostic-p.md) · [`han.args:make-arg-diagnostic`](make-arg-diagnostic.md) · [`han.args:args-result-diagnostics`](args-result-diagnostics.md) · [Source](../../../args/lexer.lisp) · [Index](../README.md)
