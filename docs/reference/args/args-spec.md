# `han.args:args-spec`

[简体中文](args-spec.zh-CN.md)

*Structure type*

## Syntax

```text
han.args:args-spec
(typep object 'han.args:args-spec) → generalized-boolean
```

## Description

All argument declarations for one command. The table maps their lookup names to individual specifications and is reused across invocations.

## Examples

Recognize the schema for a command with one option.

```lisp
(let ((specs
        (han.args:parse-args-spec
         (list (han.args:parse-arg-spec "(--/-j)jobs=1")) "report")))
  (typep specs 'han.args:args-spec))
;; => t
```

Separate a command schema from one of its member declarations.

```lisp
(let* ((item (han.args:parse-arg-spec "(--)size"))
       (schema (han.args:parse-args-spec (list item) "scan")))
  (mapcar (lambda (record)
            (etypecase record
              (han.args:args-spec (han.args:args-spec-command record))
              (han.args:arg-spec (han.args:arg-spec-name record))))
          (list schema item)))
;; => ("scan" "size")
```

[`han.args:args-spec-p`](args-spec-p.md) · [`han.args:make-args-spec`](make-args-spec.md) · [`han.args:parse-args-spec`](parse-args-spec.md) · [Source](../../../args/spec.lisp) · [Index](../README.md)
