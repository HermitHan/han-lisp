# `han.args:arg-diagnostic-p`

[简体中文](arg-diagnostic-p.zh-CN.md)

*Predicate*

## Syntax

```text
(han.args:arg-diagnostic-p object) → generalized-boolean
```

## Description

Recognize a `arg-diagnostic` structure. Any Lisp object can be passed. The predicate inspects its type without changing it.

## Examples

Recognize the record generated for a token spelling warning. Compare it with an unrelated keyword.

```lisp
(let ((diagnostic
        (first (han.args:args-input-diagnostics
                (han.args:parse-args-input '("demo" "--"))))))
  (list (han.args:arg-diagnostic-p diagnostic) (han.args:arg-diagnostic-p :unparsed)))
;; => (t nil)
```

Separate reported warnings from application events.

```lisp
(let ((items (list :started (han.args:make-arg-diagnostic :kind :warning)
                   "message" (han.args:make-arg-diagnostic :kind :error))))
  (mapcar #'han.args:arg-diagnostic-kind
          (remove-if-not #'han.args:arg-diagnostic-p items)))
;; => (:warning :error)
```

[`han.args:arg-diagnostic`](arg-diagnostic.md) · [`han.args:args-result-diagnostics`](args-result-diagnostics.md) · [Source](../../../args/lexer.lisp) · [Index](../README.md)
