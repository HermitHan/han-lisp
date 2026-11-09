# `han.args:arg-token-value`

[简体中文](arg-token-value.zh-CN.md)

*Accessor*

## Syntax

```text
(han.args:arg-token-value token) → string or nil
(setf (han.args:arg-token-value token) new-value) → new-value
```

## Description

Return the normalized token value. An option yields the name without dashes or attached value, a named slot yields its name, and an ordinary value yields its text. The switch `@:` has value `nil`.

## Examples

Read the lookup name from an attached option.

```lisp
(let ((token
        (aref (han.args:args-input-tokens
               (han.args:parse-args-input '("demo" "--jobs=4")))
              0)))
  (han.args:arg-token-value token))
;; => "jobs"
```

Read the markers for entering a slot and returning to the top level.

```lisp
(let ((input
        (han.args:parse-args-input '("demo" "@files:" "a.txt" "@:"))))
  (map 'list #'han.args:arg-token-value (han.args:args-input-tokens input)))
;; => ("files" "a.txt" nil)
```

[`han.args:arg-token`](arg-token.md) · [`han.args:parse-args-input`](parse-args-input.md) · [Source](../../../args/lexer.lisp) · [Index](../README.md)
