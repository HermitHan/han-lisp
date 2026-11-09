# `han.args:args-spec-p`

[简体中文](args-spec-p.zh-CN.md)

*Predicate*

## Syntax

```text
(han.args:args-spec-p object) → generalized-boolean
```

## Description

Recognize a `args-spec` structure. Any Lisp object can be passed. The predicate inspects its type without changing it.

## Examples

Recognize the schema for a command with one option. Compare it with an unrelated keyword.

```lisp
(let ((specs
        (han.args:parse-args-spec
         (list (han.args:parse-arg-spec "(--/-j)jobs=1")) "report")))
  (list (han.args:args-spec-p specs) (han.args:args-spec-p :unparsed)))
;; => (t nil)
```

Choose the compiled command schema from mixed setup objects.

```lisp
(let* ((field (han.args:parse-arg-spec "$1"))
       (models (list field (han.args:parse-args-spec (list field) "report"))))
  (han.args:args-spec-command (find-if #'han.args:args-spec-p models)))
;; => "report"
```

[`han.args:args-spec`](args-spec.md) · [`han.args:parse-args-spec`](parse-args-spec.md) · [Source](../../../args/spec.lisp) · [Index](../README.md)
