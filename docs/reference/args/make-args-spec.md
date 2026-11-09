# `han.args:make-args-spec`

[简体中文](make-args-spec.zh-CN.md)

*Constructor*

## Syntax

```text
(han.args:make-args-spec &key command args-table) → han.args:args-spec
```

## Description

Construct and return a fresh `args-spec` with the supplied keyword fields. Omitted fields default to `nil`. Provide an `equalp` hash table keyed by argument name for use with the binder. `parse-args-spec` also checks entry collisions and position numbering.

## Examples

Name a command and supply an empty declaration table.

```lisp
(let ((specs
        (han.args:make-args-spec
         :command "report" :args-table (make-hash-table :test 'equalp))))
  (han.args:args-spec-command specs))
;; => "report"
```

Bind a manually indexed declaration.

```lisp
(let ((fields (make-hash-table :test 'equalp)))
  (setf (gethash "file" fields) (han.args:parse-arg-spec "(--)file"))
  (let* ((schema (han.args:make-args-spec :args-table fields :command "list"))
         (result (han.args:bind-args schema
                                     (han.args:parse-args-input '("list" "--file=x")))))
    (han.args:get-arg "FILE" result)))
;; => values ("x" :input)
```

[`han.args:args-spec`](args-spec.md) · [`han.args:args-spec-command`](args-spec-command.md) · [`han.args:parse-args-spec`](parse-args-spec.md) · [Source](../../../args/spec.lisp) · [Index](../README.md)
