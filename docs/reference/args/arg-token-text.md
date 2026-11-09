# `han.args:arg-token-text`

[简体中文](arg-token-text.zh-CN.md)

*Accessor*

## Syntax

```text
(han.args:arg-token-text token) → string
(setf (han.args:arg-token-text token) new-value) → new-value
```

## Description

Return the complete original argument, including its dashes, slot punctuation, or attached value. Use this field when forwarding a block to another program.

## Examples

Recover the spelling passed by the caller.

```lisp
(let ((token
        (aref (han.args:args-input-tokens
               (han.args:parse-args-input '("demo" "--jobs=4")))
              0)))
  (han.args:arg-token-text token))
;; => "--jobs=4"
```

Forward the original strings in a block, including an empty argument.

```lisp
(let ((input
        (han.args:parse-args-input '("demo" "@child:" "--title" "two words" ""))))
  (map 'list #'han.args:arg-token-text (han.args:args-input-tokens input)))
;; => ("@child:" "--title" "two words" "")
```

[`han.args:arg-token`](arg-token.md) · [`han.args:parse-args-input`](parse-args-input.md) · [Source](../../../args/lexer.lisp) · [Index](../README.md)
