# `han.args:arg-binding-spec`

*Accessor · 访问器*

## Syntax · 语法

```text
(han.args:arg-binding-spec binding) → arg-spec or nil
(setf (han.args:arg-binding-spec binding) new-value) → new-value
```

## Description · 说明

Return the declaration that produced this binding. The binder stores the matched `arg-spec` so callers can inspect its arity or defaults. A binding supplied through a built-in table can omit this field.

返回产生该绑定的规格。绑定器会记录匹配到的 `arg-spec`，便于查看其形态或默认值。调用方通过内置表注入绑定时可以省略该字段。

## Examples · 示例

Inspect the mode of the originating declaration. 查看产生这条绑定的声明形态。

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

Inject a contextual value without a command declaration. 为上下文注入值的绑定可以省略命令行规格。

```lisp
(han.args:arg-binding-spec
 (han.args:make-arg-binding :name "site" :value "local" :status :input))
;; => nil
```

[`han.args:arg-binding`](arg-binding.md) · [`han.args:get-arg`](get-arg.md) · [Source · 源码](../../../args/bind.lisp) · [Index · 索引](../README.md)
