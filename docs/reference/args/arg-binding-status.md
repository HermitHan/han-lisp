# `han.args:arg-binding-status`

[简体中文](arg-binding-status.zh-CN.md)

*Accessor*

## Syntax

```text
(han.args:arg-binding-status binding) → keyword
(setf (han.args:arg-binding-status binding) new-value) → new-value
```

## Description

Return the binder's classification, `:input`, `:default`, `:missing`, or `:conflict`. This is the status before evaluating a reference in a default expression.

## Examples

Identify a value supplied by the caller.

```lisp
(let ((binding
        (gethash "jobs"
                 (han.args:args-result-bindings
                  (han.args:bind-args
                   (han.args:parse-args-spec
                    (list (han.args:parse-arg-spec "(--/-j)jobs=1")))
                   (han.args:parse-args-input '("demo" "-j" "4")))))))
  (han.args:arg-binding-status binding))
;; => :input
```

Separate absent options from options supplied twice.

```lisp
(let ((result
        (han.args:bind-args
         (han.args:parse-args-spec
          (mapcar #'han.args:parse-arg-spec '("(--)name" "(--)verbose?")))
         (han.args:parse-args-input '("demo" "--name=A" "--name=B")))))
  (mapcar (lambda (key)
            (han.args:arg-binding-status
             (gethash key (han.args:args-result-bindings result))))
          '("name" "verbose")))
;; => (:conflict :missing)
```

[`han.args:arg-binding`](arg-binding.md) · [`han.args:get-arg`](get-arg.md) · [Source](../../../args/bind.lisp) · [Index](../README.md)
