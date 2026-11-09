# `han.args:arg-binding-p`

[简体中文](arg-binding-p.zh-CN.md)

*Predicate*

## Syntax

```text
(han.args:arg-binding-p object) → generalized-boolean
```

## Description

Recognize a `arg-binding` structure. Any Lisp object can be passed. The predicate inspects its type without changing it.

## Examples

Recognize one value record returned from a binding table. Compare it with an unrelated keyword.

```lisp
(let ((binding
        (gethash "jobs"
                 (han.args:args-result-bindings
                  (han.args:bind-args
                   (han.args:parse-args-spec
                    (list (han.args:parse-arg-spec "(--/-j)jobs=1")))
                   (han.args:parse-args-input '("demo" "-j" "4")))))))
  (list (han.args:arg-binding-p binding) (han.args:arg-binding-p :unparsed)))
;; => (t nil)
```

Distinguish a known absent option from an unregistered key.

```lisp
(let ((result
        (han.args:bind-args
         (han.args:parse-args-spec
          (mapcar #'han.args:parse-arg-spec '("(--)verbose?")))
         (han.args:parse-args-input '("demo")))))
  (mapcar (lambda (key)
            (let ((value (gethash key (han.args:args-result-bindings result))))
              (if (han.args:arg-binding-p value) (han.args:arg-binding-status value) :unknown)))
          '("verbose" "quiet")))
;; => (:missing :unknown)
```

[`han.args:arg-binding`](arg-binding.md) · [`han.args:get-arg`](get-arg.md) · [Source](../../../args/bind.lisp) · [Index](../README.md)
