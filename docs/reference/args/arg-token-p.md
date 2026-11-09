# `han.args:arg-token-p`

[简体中文](arg-token-p.zh-CN.md)

*Predicate*

## Syntax

```text
(han.args:arg-token-p object) → generalized-boolean
```

## Description

Recognize a `arg-token` structure. Any Lisp object can be passed. The predicate inspects its type without changing it.

## Examples

Recognize an option record returned by the lexer. Compare it with an unrelated keyword.

```lisp
(let ((token
        (aref (han.args:args-input-tokens
               (han.args:parse-args-input '("demo" "--jobs=4")))
              0)))
  (list (han.args:arg-token-p token) (han.args:arg-token-p :unparsed)))
;; => (t nil)
```

Extract only tokens from a mixed log.

```lisp
(let ((log (list :start (han.args:make-arg-token :text "-v") :end)))
  (mapcar #'han.args:arg-token-text (remove-if-not #'han.args:arg-token-p log)))
;; => ("-v")
```

[`han.args:arg-token`](arg-token.md) · [`han.args:parse-args-input`](parse-args-input.md) · [Source](../../../args/lexer.lisp) · [Index](../README.md)
