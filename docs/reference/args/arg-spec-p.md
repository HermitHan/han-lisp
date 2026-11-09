# `han.args:arg-spec-p`

[简体中文](arg-spec-p.zh-CN.md)

*Predicate*

## Syntax

```text
(han.args:arg-spec-p object) → generalized-boolean
```

## Description

Recognize a `arg-spec` structure. Any Lisp object can be passed. The predicate inspects its type without changing it.

## Examples

Recognize a parsed option declaration. Compare it with an unrelated keyword.

```lisp
(let ((spec (han.args:parse-arg-spec "!(--/-j)jobs")))
  (list (han.args:arg-spec-p spec) (han.args:arg-spec-p :unparsed)))
;; => (t nil)
```

Convert strings into declarations exactly once.

```lisp
(let ((entries (list "a=1" (han.args:parse-arg-spec "b=2"))))
  (mapcar (lambda (x)
            (han.args:arg-spec-default
             (if (han.args:arg-spec-p x) x (han.args:parse-arg-spec x))))
          entries))
;; => ("1" "2")
```

[`han.args:arg-spec`](arg-spec.md) · [`han.args:parse-arg-spec`](parse-arg-spec.md) · [Source](../../../args/spec.lisp) · [Index](../README.md)
