# `han.args:make-args-result`

[简体中文](make-args-result.zh-CN.md)

*Constructor*

## Syntax

```text
(han.args:make-args-result &key spec input builtin-bindings bindings diagnostics) → han.args:args-result
```

## Description

Construct and return a fresh `args-result` with the supplied keyword fields. Omitted fields default to `nil`. For a manually assembled, queryable result, supply both binding tables. `bind-args` ordinarily constructs the complete record.

## Examples

Create the result for an empty command schema.

```lisp
(let ((result
        (han.args:make-args-result
         :spec (han.args:parse-args-spec nil)
          :input (han.args:parse-args-input '("demo"))
          :builtin-bindings (make-hash-table :test 'equalp)
          :bindings (make-hash-table :test 'equalp))))
  (han.args:args-result-diagnostics result))
;; => nil
```

Assemble a queryable result from precomputed binding tables.

```lisp
(let ((bindings (make-hash-table :test 'equalp)))
  (setf (gethash "jobs" bindings)
        (han.args:make-arg-binding :name "jobs" :value "4" :status :input))
  (han.args:get-arg "jobs"
                    (han.args:make-args-result :bindings bindings
                                               :builtin-bindings (make-hash-table))))
;; => values ("4" :input)
```

[`han.args:args-result`](args-result.md) · [`han.args:args-result-diagnostics`](args-result-diagnostics.md) · [`han.args:bind-args`](bind-args.md) · [Source](../../../args/bind.lisp) · [Index](../README.md)
