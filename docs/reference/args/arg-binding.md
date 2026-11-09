# `han.args:arg-binding`

[简体中文](arg-binding.zh-CN.md)

*Structure type*

## Syntax

```text
han.args:arg-binding
(typep object 'han.args:arg-binding) → generalized-boolean
```

## Description

The value and status assigned to one lookup name. A default expression may remain in the value slot until a query resolves its references.

## Examples

Recognize one value record returned from a binding table.

```lisp
(let ((binding
        (gethash "jobs"
                 (han.args:args-result-bindings
                  (han.args:bind-args
                   (han.args:parse-args-spec
                    (list (han.args:parse-arg-spec "(--/-j)jobs=1")))
                   (han.args:parse-args-input '("demo" "-j" "4")))))))
  (typep binding 'han.args:arg-binding))
;; => t
```

Format the status of a successful lookup and a key with no binding.

```lisp
(let ((result
        (han.args:bind-args
         (han.args:parse-args-spec
          (mapcar #'han.args:parse-arg-spec '("jobs=4")))
         (han.args:parse-args-input '("demo")))))
  (mapcar (lambda (key)
            (typecase (gethash key (han.args:args-result-bindings result))
              (han.args:arg-binding :registered)
              (null :unknown)))
          '("jobs" "other")))
;; => (:registered :unknown)
```

[`han.args:arg-binding-p`](arg-binding-p.md) · [`han.args:make-arg-binding`](make-arg-binding.md) · [`han.args:get-arg`](get-arg.md) · [Source](../../../args/bind.lisp) · [Index](../README.md)
