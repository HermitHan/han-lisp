# `han.args:arg-binding-spec`

[English](arg-binding-spec.md)

*访问器*

## 语法

```text
(han.args:arg-binding-spec binding) → arg-spec or nil
(setf (han.args:arg-binding-spec binding) new-value) → new-value
```

## 说明

返回产生该绑定的规格。绑定器会记录匹配到的 `arg-spec`，便于查看其形态或默认值。调用方通过内置表注入绑定时可以省略该字段。

## 示例

查看产生这条绑定的声明形态。

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

为上下文注入值的绑定可以省略命令行规格。

```lisp
(han.args:arg-binding-spec
 (han.args:make-arg-binding :name "site" :value "local" :status :input))
;; => nil
```

[`han.args:arg-binding`](arg-binding.zh-CN.md) · [`han.args:get-arg`](get-arg.zh-CN.md) · [源码](../../../args/bind.lisp) · [索引](../README.zh-CN.md)
