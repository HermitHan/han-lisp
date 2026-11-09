# `han.args:arg-token`

[简体中文](arg-token.zh-CN.md)

*Structure type*

## Syntax

```text
han.args:arg-token
(typep object 'han.args:arg-token) → generalized-boolean
```

## Description

A parsed argv element with its original spelling, normalized value, and position. Named slot switches are tokens too.

## Examples

Check the type of an option record returned by the lexer.

```lisp
(let ((token
        (aref (han.args:args-input-tokens
               (han.args:parse-args-input '("demo" "--jobs=4")))
              0)))
  (typep token 'han.args:arg-token))
;; => t
```

Inspect a token and preserve plain text from a mixed forwarding queue.

```lisp
(let ((queue (list (han.args:make-arg-token :text "--help") "raw")))
  (mapcar (lambda (item)
            (etypecase item
              (han.args:arg-token (han.args:arg-token-text item))
              (string item)))
          queue))
;; => ("--help" "raw")
```

[`han.args:arg-token-p`](arg-token-p.md) · [`han.args:make-arg-token`](make-arg-token.md) · [`han.args:parse-args-input`](parse-args-input.md) · [Source](../../../args/lexer.lisp) · [Index](../README.md)
