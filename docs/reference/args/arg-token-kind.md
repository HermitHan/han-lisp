# `han.args:arg-token-kind`

[简体中文](arg-token-kind.zh-CN.md)

*Accessor*

## Syntax

```text
(han.args:arg-token-kind token) → keyword
(setf (han.args:arg-token-kind token) new-value) → new-value
```

## Description

Return the lexical class of the element. Parsed tokens use `:long-option`, `:short-option`, `:slot-switch`, or `:value`. Classification happens before matching against the command's declarations.

## Examples

Identify an attached long option.

```lisp
(let ((token
        (aref (han.args:args-input-tokens
               (han.args:parse-args-input '("demo" "--jobs=4")))
              0)))
  (han.args:arg-token-kind token))
;; => :long-option
```

Classify tokens before binding any options.

```lisp
(let ((input
        (han.args:parse-args-input '("demo" "-v" "--mode=fast" "@file:" "one"))))
  (map 'list #'han.args:arg-token-kind (han.args:args-input-tokens input)))
;; => (:short-option :long-option :slot-switch :value)
```

[`han.args:arg-token`](arg-token.md) · [`han.args:parse-args-input`](parse-args-input.md) · [Source](../../../args/lexer.lisp) · [Index](../README.md)
