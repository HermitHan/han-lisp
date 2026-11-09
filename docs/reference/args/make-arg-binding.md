# `han.args:make-arg-binding`

[简体中文](make-arg-binding.zh-CN.md)

*Constructor*

## Syntax

```text
(han.args:make-arg-binding &key name spec value status) → han.args:arg-binding
```

## Description

Construct and return a fresh `arg-binding` with the supplied keyword fields. Omitted fields default to `nil`. This constructor is useful when injecting built-in values. Choose an explicit status so that lookup can recognize the binding.

## Examples

Record an explicit value and its provenance.

```lisp
(let ((binding
        (han.args:make-arg-binding
         :name "jobs" :value "4" :status :input)))
  (han.args:arg-binding-value binding))
;; => "4"
```

Use a manually constructed binding as a built-in default.

```lisp
(let ((builtins (make-hash-table :test 'equalp)))
  (setf (gethash "mode" builtins)
        (han.args:make-arg-binding :name "mode" :value "batch" :status :default))
  (han.args:get-arg "mode" (han.args:bind-args (han.args:parse-args-spec nil)
                                              (han.args:parse-args-input '("demo")) builtins)))
;; => values ("batch" :default)
```

[`han.args:arg-binding`](arg-binding.md) · [`han.args:arg-binding-value`](arg-binding-value.md) · [`han.args:get-arg`](get-arg.md) · [Source](../../../args/bind.lisp) · [Index](../README.md)
