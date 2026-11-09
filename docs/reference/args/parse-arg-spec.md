# `han.args:parse-arg-spec`

[简体中文](parse-arg-spec.zh-CN.md)

*Function*

## Syntax

```text
(han.args:parse-arg-spec spec-string) → arg-spec
```

## Description

Parse a single declaration string. The return value records lookup name, long/short/slot spellings, arity, requirement, visibility, and default expression. Malformed syntax, a mixed slot/option declaration, or an invalid default reference can signal an error while building the command specification.

## Examples

Expand short and long aliases while retaining a literal default.

```lisp
(let ((spec (han.args:parse-arg-spec "(--/-)jobs=4")))
  (list (han.args:arg-spec-name spec)
        (han.args:arg-spec-short-entry spec)
        (han.args:arg-spec-default spec)))
;; => ("jobs" "-j" "4")
```

Inspect a default assembled from a field reference and a suffix.

```lisp
(han.args:arg-spec-default (han.args:parse-arg-spec "out=@{name}.txt"))
;; => (:concat (:query "name") ".txt")
```

Reject an unclosed reference in a default.

```lisp
(han.args:parse-arg-spec "out=@{name")
;; signals simple-error
```

Treat a positional declaration as required.

```lisp
(let ((spec
        (han.args:parse-arg-spec "$0")))
  (values (han.args:arg-spec-name spec) (han.args:arg-spec-required spec)))
;; => values (0 t)
```

[`han.args:arg-spec`](arg-spec.md) · [`han.args:parse-args-spec`](parse-args-spec.md) · [Source](../../../args/spec.lisp) · [Index](../README.md)
