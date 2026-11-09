# `han.args:args-spec-command`

[简体中文](args-spec-command.zh-CN.md)

*Accessor*

## Syntax

```text
(han.args:args-spec-command specs) → string
(setf (han.args:args-spec-command specs) new-value) → new-value
```

## Description

Return the label supplied to `parse-args-spec`. It defaults to `"my-args"`. To inspect the actual command string from a particular invocation, use `args-input-raw-cmd`.

## Examples

Read the label of a command schema.

```lisp
(let ((specs
        (han.args:parse-args-spec
         (list (han.args:parse-arg-spec "(--/-j)jobs=1")) "report")))
  (han.args:args-spec-command specs))
;; => "report"
```

Inspect the default label when no command was given.

```lisp
(han.args:args-spec-command (han.args:parse-args-spec nil))
;; => "my-args"
```

[`han.args:args-spec`](args-spec.md) · [`han.args:parse-args-spec`](parse-args-spec.md) · [Source](../../../args/spec.lisp) · [Index](../README.md)
