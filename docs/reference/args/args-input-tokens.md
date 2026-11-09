# `han.args:args-input-tokens`

[简体中文](args-input-tokens.zh-CN.md)

*Accessor*

## Syntax

```text
(han.args:args-input-tokens input) → vector
(setf (han.args:args-input-tokens input) new-value) → new-value
```

## Description

Return the vector of `arg-token` records, in argv order, including slot switches. Use `aref` with a token position or an index from `arg-segment-positions`.

## Examples

Inspect token kinds in argv order.

```lisp
(let ((input (han.args:parse-args-input '("demo" "notes.txt" "@filter:" "--mode=fast"))))
  (map 'list #'han.args:arg-token-kind (han.args:args-input-tokens input)))
;; => (:value :slot-switch :long-option)
```

Inspect an invocation with no arguments.

```lisp
(let ((input
        (han.args:parse-args-input '("demo"))))
  (values (vectorp (han.args:args-input-tokens input))
          (length (han.args:args-input-tokens input))))
;; => values (t 0)
```

[`han.args:args-input`](args-input.md) · [`han.args:parse-args-input`](parse-args-input.md) · [Source](../../../args/lexer.lisp) · [Index](../README.md)
