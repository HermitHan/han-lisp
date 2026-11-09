# `han.args:args-input-raw-argv`

[简体中文](args-input-raw-argv.zh-CN.md)

*Accessor*

## Syntax

```text
(han.args:args-input-raw-argv input) → list of strings
(setf (han.args:args-input-raw-argv input) new-value) → new-value
```

## Description

Return the argument strings following the command name, with their original spelling, order, and argument boundaries intact.

## Examples

Retrieve the arguments following a command.

```lisp
(let ((input (han.args:parse-args-input '("demo" "notes.txt" "@filter:" "--mode=fast"))))
  (han.args:args-input-raw-argv input))
;; => ("notes.txt" "@filter:" "--mode=fast")
```

Preserve argument boundaries from the calling process.

```lisp
(han.args:args-input-raw-argv
 (han.args:parse-args-input '("inspect" "a b" "" "--")))
;; => ("a b" "" "--")
```

[`han.args:args-input`](args-input.md) · [`han.args:parse-args-input`](parse-args-input.md) · [Source](../../../args/lexer.lisp) · [Index](../README.md)
