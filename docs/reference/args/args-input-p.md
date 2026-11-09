# `han.args:args-input-p`

[简体中文](args-input-p.zh-CN.md)

*Predicate*

## Syntax

```text
(han.args:args-input-p object) → generalized-boolean
```

## Description

Recognize a `args-input` structure. Any Lisp object can be passed. The predicate inspects its type without changing it.

## Examples

Recognize the object representing a complete invocation. Compare it with an unrelated keyword.

```lisp
(let ((input (han.args:parse-args-input '("demo" "notes.txt" "@filter:" "--mode=fast"))))
  (list (han.args:args-input-p input) (han.args:args-input-p :unparsed)))
;; => (t nil)
```

Reuse already parsed arguments at a library boundary.

```lisp
(flet ((ensure-input (value)
         (if (han.args:args-input-p value) value (han.args:parse-args-input value))))
  (let ((old (han.args:parse-args-input '("scan"))))
    (values (eq (ensure-input old) old)
            (han.args:args-input-raw-cmd (ensure-input '("pack"))))))
;; => values (t "pack")
```

[`han.args:args-input`](args-input.md) · [`han.args:parse-args-input`](parse-args-input.md) · [Source](../../../args/lexer.lisp) · [Index](../README.md)
