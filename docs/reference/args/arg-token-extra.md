# `han.args:arg-token-extra`

[简体中文](arg-token-extra.zh-CN.md)

*Accessor*

## Syntax

```text
(han.args:arg-token-extra token) → string or nil
(setf (han.args:arg-token-extra token) new-value) → new-value
```

## Description

For an option with `=`, return the part after the first equals sign with surrounding space characters trimmed. `--jobs=` yields the empty string. An option without `=` has `nil` here even when the next token supplies its value.

## Examples

Extract a value attached by an equals sign.

```lisp
(let ((token
        (aref (han.args:args-input-tokens
               (han.args:parse-args-input '("demo" "--jobs=4")))
              0)))
  (han.args:arg-token-extra token))
;; => "4"
```

Distinguish a missing attached value from an explicitly empty one.

```lisp
(let ((input
        (han.args:parse-args-input '("demo" "--name" "--name=" "--name=a=b"))))
  (map 'list #'han.args:arg-token-extra (han.args:args-input-tokens input)))
;; => (nil "" "a=b")
```

[`han.args:arg-token`](arg-token.md) · [`han.args:parse-args-input`](parse-args-input.md) · [Source](../../../args/lexer.lisp) · [Index](../README.md)
