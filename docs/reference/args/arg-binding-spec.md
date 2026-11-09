# `han.args:arg-binding-spec`

[简体中文](arg-binding-spec.zh-CN.md)

*Accessor*

## Syntax

```text
(han.args:arg-binding-spec binding) → arg-spec or nil
(setf (han.args:arg-binding-spec binding) new-value) → new-value
```

## Description

Return the declaration that produced this binding. The binder stores the matched `arg-spec` so callers can inspect its arity or defaults. A binding supplied through a built-in table can omit this field.

## Examples

Inspect the mode of the originating declaration.

```lisp
(let ((binding
        (gethash "jobs"
                 (han.args:args-result-bindings
                  (han.args:bind-args
                   (han.args:parse-args-spec
                    (list (han.args:parse-arg-spec "(--/-j)jobs=1")))
                   (han.args:parse-args-input '("demo" "-j" "4")))))))
  (han.args:arg-spec-arity (han.args:arg-binding-spec binding)))
;; => :single
```

Inject a contextual value without a command declaration.

```lisp
(han.args:arg-binding-spec
 (han.args:make-arg-binding :name "site" :value "local" :status :input))
;; => nil
```

[`han.args:arg-binding`](arg-binding.md) · [`han.args:get-arg`](get-arg.md) · [Source](../../../args/bind.lisp) · [Index](../README.md)
