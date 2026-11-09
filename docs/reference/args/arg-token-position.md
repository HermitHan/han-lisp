# `han.args:arg-token-position`

[简体中文](arg-token-position.zh-CN.md)

*Accessor*

## Syntax

```text
(han.args:arg-token-position token) → nonnegative integer
(setf (han.args:arg-token-position token) new-value) → new-value
```

## Description

Return the zero-based index in the arguments following the command name. The same index addresses the token in `args-input-tokens`.

## Examples

Find the first argument after the command.

```lisp
(let ((token
        (aref (han.args:args-input-tokens
               (han.args:parse-args-input '("demo" "--jobs=4")))
              0)))
  (han.args:arg-token-position token))
;; => 0
```

Locate an argument after a slot switch.

```lisp
(let ((input
        (han.args:parse-args-input '("demo" "@files:" "a.txt" "@:" "-v"))))
  (map 'list #'han.args:arg-token-position (han.args:args-input-tokens input)))
;; => (0 1 2 3)
```

[`han.args:arg-token`](arg-token.md) · [`han.args:parse-args-input`](parse-args-input.md) · [Source](../../../args/lexer.lisp) · [Index](../README.md)
