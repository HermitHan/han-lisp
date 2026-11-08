# `han.args:arg-binding-status`

*Accessor · 访问器*

## Syntax · 语法

```text
(han.args:arg-binding-status binding) → keyword
(setf (han.args:arg-binding-status binding) new-value) → new-value
```

## Description · 说明

Return the binder's classification, `:input`, `:default`, `:missing`, or `:conflict`. This is the status before evaluating a reference in a default expression.

返回绑定器给出的状态，即 `:input`、`:default`、`:missing` 或 `:conflict`。此处反映的是求取默认表达式中引用之前的状态。

## Examples · 示例

Identify a value supplied by the caller. 辨认来自本次输入的参数值。

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

Separate absent options from options supplied twice. 在一次绑定中分辨缺省开关和被重复提供的单值参数。

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

[`han.args:arg-binding`](arg-binding.md) · [`han.args:get-arg`](get-arg.md) · [Source · 源码](../../../args/bind.lisp) · [Index · 索引](../README.md)
