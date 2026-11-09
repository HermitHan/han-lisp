# `han.args:arg-binding-status`

[English](arg-binding-status.md)

*访问器*

## 语法

```text
(han.args:arg-binding-status binding) → keyword
(setf (han.args:arg-binding-status binding) new-value) → new-value
```

## 说明

返回绑定器给出的状态，即 `:input`、`:default`、`:missing` 或 `:conflict`。此处反映的是求取默认表达式中引用之前的状态。

## 示例

辨认来自本次输入的参数值。

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

在一次绑定中分辨缺省开关和被重复提供的单值参数。

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

[`han.args:arg-binding`](arg-binding.zh-CN.md) · [`han.args:get-arg`](get-arg.zh-CN.md) · [源码](../../../args/bind.lisp) · [索引](../README.zh-CN.md)
