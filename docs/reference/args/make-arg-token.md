# `han.args:make-arg-token`

[简体中文](make-arg-token.zh-CN.md)

*Constructor*

## Syntax

```text
(han.args:make-arg-token &key kind text value extra position) → han.args:arg-token
```

## Description

Construct and return a fresh `arg-token` with the supplied keyword fields. Omitted fields default to `nil`. Its fields are normally filled together by the lexer, which assigns the position after removing the command name.

## Examples

Supply both a raw spelling and an attached value.

```lisp
(let ((token
        (han.args:make-arg-token
         :kind :long-option :text "--jobs=4" :value "jobs" :extra "4" :position 0)))
  (han.args:arg-token-text token))
;; => "--jobs=4"
```

Construct an ordinary value containing an equals sign.

```lisp
(let ((token (han.args:make-arg-token :kind :value :text "a=b" :value "a=b")))
  (values (han.args:arg-token-value token) (han.args:arg-token-extra token)))
;; => values ("a=b" nil)
```

[`han.args:arg-token`](arg-token.md) · [`han.args:arg-token-text`](arg-token-text.md) · [`han.args:parse-args-input`](parse-args-input.md) · [Source](../../../args/lexer.lisp) · [Index](../README.md)
