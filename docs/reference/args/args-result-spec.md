# `han.args:args-result-spec`

[简体中文](args-result-spec.zh-CN.md)

*Accessor*

## Syntax

```text
(han.args:args-result-spec result) → args-spec
(setf (han.args:args-result-spec result) new-value) → new-value
```

## Description

Return the command specification passed to `bind-args`. Its table contains all declarations for this binding operation.

## Examples

Recover the label of the schema used for binding.

```lisp
(let ((result
        (han.args:bind-args
         (han.args:parse-args-spec (list (han.args:parse-arg-spec "(--/-j)jobs=1")))
         (han.args:parse-args-input '("demo" "-j" "4")))))
  (han.args:args-spec-command (han.args:args-result-spec result)))
;; => "my-args"
```

Share a command specification across invocations.

```lisp
(let ((specs
        (han.args:parse-args-spec
         (mapcar #'han.args:parse-arg-spec '("(--)jobs=1")))))
  (eq specs (han.args:args-result-spec
             (han.args:bind-args specs (han.args:parse-args-input '("demo"))))))
;; => t
```

[`han.args:args-result`](args-result.md) · [`han.args:bind-args`](bind-args.md) · [Source](../../../args/bind.lisp) · [Index](../README.md)
