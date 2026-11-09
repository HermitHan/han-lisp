# `han.args:args-result-diagnostics`

[简体中文](args-result-diagnostics.zh-CN.md)

*Accessor*

## Syntax

```text
(han.args:args-result-diagnostics result) → list of arg-diagnostic
(setf (han.args:args-result-diagnostics result) new-value) → new-value
```

## Description

Return the collected lexer and binding diagnostics. Empty means that neither phase reported a warning or error for this result. Inspect each item's kind or code before using the bound values.

## Examples

Verify that a valid invocation has no diagnostics.

```lisp
(let ((result
        (han.args:bind-args
         (han.args:parse-args-spec (list (han.args:parse-arg-spec "(--/-j)jobs=1")))
         (han.args:parse-args-input '("demo" "-j" "4")))))
  (han.args:args-result-diagnostics result))
;; => nil
```

Locate an option whose value was omitted.

```lisp
(let ((result
        (han.args:bind-args
         (han.args:parse-args-spec
          (mapcar #'han.args:parse-arg-spec '("(--)name")))
         (han.args:parse-args-input '("demo" "--name")))))
  (let ((d (first (han.args:args-result-diagnostics result))))
    (values (han.args:arg-diagnostic-kind d)
            (han.args:arg-diagnostic-code d)
            (han.args:arg-diagnostic-position d))))
;; => values (:error :missing-option-value 0)
```

[`han.args:args-result`](args-result.md) · [`han.args:bind-args`](bind-args.md) · [Source](../../../args/bind.lisp) · [Index](../README.md)
