# `han.args:arg-binding-value`

[简体中文](arg-binding-value.zh-CN.md)

*Accessor*

## Syntax

```text
(han.args:arg-binding-value binding) → object
(setf (han.args:arg-binding-value binding) new-value) → new-value
```

## Description

Return the raw stored value. An option can hold a string, a present flag holds `t`, and a supplied block holds a token list. A reference in a default remains an expression here. `get-arg` evaluates it on demand.

## Examples

Read the user-supplied value without conversion.

```lisp
(let ((binding
        (gethash "jobs"
                 (han.args:args-result-bindings
                  (han.args:bind-args
                   (han.args:parse-args-spec
                    (list (han.args:parse-arg-spec "(--/-j)jobs=1")))
                   (han.args:parse-args-input '("demo" "-j" "4")))))))
  (han.args:arg-binding-value binding))
;; => "4"
```

Inspect a deferred default before and after resolving its reference.

```lisp
(let ((result
        (han.args:bind-args
         (han.args:parse-args-spec
          (mapcar #'han.args:parse-arg-spec '("name=ada" "alias=@name")))
         (han.args:parse-args-input '("demo")))))
  (let ((binding (gethash "alias" (han.args:args-result-bindings result))))
    (values (han.args:arg-binding-value binding)
            (han.args:get-arg "alias" result))))
;; => values ((:query "name") "ada")
```

[`han.args:arg-binding`](arg-binding.md) · [`han.args:get-arg`](get-arg.md) · [Source](../../../args/bind.lisp) · [Index](../README.md)
