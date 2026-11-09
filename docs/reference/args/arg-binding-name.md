# `han.args:arg-binding-name`

[简体中文](arg-binding-name.zh-CN.md)

*Accessor*

## Syntax

```text
(han.args:arg-binding-name binding) → string or integer
(setf (han.args:arg-binding-name binding) new-value) → new-value
```

## Description

Return the lookup key for this binding. It is a string for a named argument or an integer for a positional argument. The key is stored independently of the argv spelling used by the caller.

## Examples

Read the canonical key after a short option was used.

```lisp
(let ((binding
        (gethash "jobs"
                 (han.args:args-result-bindings
                  (han.args:bind-args
                   (han.args:parse-args-spec
                    (list (han.args:parse-arg-spec "(--/-j)jobs=1")))
                   (han.args:parse-args-input '("demo" "-j" "4")))))))
  (han.args:arg-binding-name binding))
;; => "jobs"
```

Recover the integer key from a positional binding.

```lisp
(let ((result
        (han.args:bind-args
         (han.args:parse-args-spec
          (mapcar #'han.args:parse-arg-spec '("$1")))
         (han.args:parse-args-input '("demo" "readme.md")))))
  (let ((binding (gethash 1 (han.args:args-result-bindings result))))
    (values (han.args:arg-binding-name binding)
            (han.args:arg-binding-value binding))))
;; => values (1 "readme.md")
```

[`han.args:arg-binding`](arg-binding.md) · [`han.args:get-arg`](get-arg.md) · [Source](../../../args/bind.lisp) · [Index](../README.md)
