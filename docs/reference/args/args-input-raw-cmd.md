# `han.args:args-input-raw-cmd`

[简体中文](args-input-raw-cmd.zh-CN.md)

*Accessor*

## Syntax

```text
(han.args:args-input-raw-cmd input) → string or nil
(setf (han.args:args-input-raw-cmd input) new-value) → new-value
```

## Description

Return the first string of the combined input list. This is the command name. Empty input yields `nil`.

## Examples

Separate the executable name from the argument list.

```lisp
(let ((input (han.args:parse-args-input '("demo" "notes.txt" "@filter:" "--mode=fast"))))
  (han.args:args-input-raw-cmd input))
;; => "demo"
```

Supply the command name separately when argv contains only options.

```lisp
(han.args:args-input-raw-cmd
 (han.args:parse-args-input '("-v") '("inspect")))
;; => "inspect"
```

[`han.args:args-input`](args-input.md) · [`han.args:parse-args-input`](parse-args-input.md) · [Source](../../../args/lexer.lisp) · [Index](../README.md)
