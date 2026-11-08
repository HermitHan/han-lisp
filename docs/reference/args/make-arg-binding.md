# `han.args:make-arg-binding`

*Constructor · 构造器*

## Syntax · 语法

```text
(han.args:make-arg-binding &key name spec value status) → han.args:arg-binding
```

## Description · 说明

Construct and return a fresh `arg-binding` with the supplied keyword fields. Omitted fields default to `nil`. This constructor is useful when injecting built-in values. Choose an explicit status so that lookup can recognize the binding.

根据给定的关键字字段创建并返回新的 `arg-binding` 对象。省略的字段默认为 `nil`。需要注入内置参数时可使用该构造器。显式指定状态，查询时才能识别该绑定。

## Examples · 示例

Record an explicit value and its provenance. 保存显式值及其输入状态。

```lisp
(let ((binding
        (han.args:make-arg-binding
         :name "jobs" :value "4" :status :input)))
  (han.args:arg-binding-value binding))
;; => "4"
```

Use a manually constructed binding as a built-in default. 用手工构造的内置绑定给未声明的上下文键提供默认值。

```lisp
(let ((builtins (make-hash-table :test 'equalp)))
  (setf (gethash "mode" builtins)
        (han.args:make-arg-binding :name "mode" :value "batch" :status :default))
  (han.args:get-arg "mode" (han.args:bind-args (han.args:parse-args-spec nil)
                                              (han.args:parse-args-input '("demo")) builtins)))
;; => values ("batch" :default)
```

[`han.args:arg-binding`](arg-binding.md) · [`han.args:arg-binding-value`](arg-binding-value.md) · [`han.args:get-arg`](get-arg.md) · [Source · 源码](../../../args/bind.lisp) · [Index · 索引](../README.md)
