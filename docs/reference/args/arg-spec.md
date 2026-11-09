# `han.args:arg-spec`

[简体中文](arg-spec.zh-CN.md)

*Structure type*

## Syntax

```text
han.args:arg-spec
(typep object 'han.args:arg-spec) → generalized-boolean
```

## Description

The declaration for one argument. Its lookup name, entry spellings, arity, and default determine how the binder interprets matching argv items.

## Examples

Check the type of a parsed option declaration.

```lisp
(let ((spec (han.args:parse-arg-spec "!(--/-j)jobs")))
  (typep spec 'han.args:arg-spec))
;; => t
```

Normalize a declaration string and an existing specification in the same schema.

```lisp
(let ((decls (list (han.args:parse-arg-spec "(--)name") "$1")))
  (mapcar (lambda (decl)
            (han.args:arg-spec-name
             (etypecase decl
               (string (han.args:parse-arg-spec decl))
               (han.args:arg-spec decl))))
          decls))
;; => ("name" 1)
```

[`han.args:arg-spec-p`](arg-spec-p.md) · [`han.args:make-arg-spec`](make-arg-spec.md) · [`han.args:parse-arg-spec`](parse-arg-spec.md) · [Source](../../../args/spec.lisp) · [Index](../README.md)
