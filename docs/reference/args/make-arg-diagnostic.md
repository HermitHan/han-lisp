# `han.args:make-arg-diagnostic`

[简体中文](make-arg-diagnostic.zh-CN.md)

*Constructor*

## Syntax

```text
(han.args:make-arg-diagnostic &key kind code message position) → han.args:arg-diagnostic
```

## Description

Construct and return a fresh `arg-diagnostic` with the supplied keyword fields. Omitted fields default to `nil`. Use `:error` or `:warning` as the severity and set a position only when an input token provides a location.

## Examples

Attach an explanation and position to an application warning.

```lisp
(let ((diagnostic
        (han.args:make-arg-diagnostic
         :kind :warning :code :unused-option :message "Extra filename" :position 2)))
  (han.args:arg-diagnostic-code diagnostic))
;; => :unused-option
```

Create a diagnostic for an error without a token location.

```lisp
(let ((item (han.args:make-arg-diagnostic :kind :error :message "No output selected")))
  (values (han.args:arg-diagnostic-kind item)
          (han.args:arg-diagnostic-code item)
          (han.args:arg-diagnostic-position item)))
;; => values (:error nil nil)
```

[`han.args:arg-diagnostic`](arg-diagnostic.md) · [`han.args:arg-diagnostic-code`](arg-diagnostic-code.md) · [`han.args:args-result-diagnostics`](args-result-diagnostics.md) · [Source](../../../args/lexer.lisp) · [Index](../README.md)
