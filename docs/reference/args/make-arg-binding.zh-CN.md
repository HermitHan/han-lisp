# `han.args:make-arg-binding`

[English](make-arg-binding.md)

*构造器*

## 语法

```text
(han.args:make-arg-binding &key name spec value status) → han.args:arg-binding
```

## 说明

根据给定的关键字字段创建并返回新的 `arg-binding` 对象。省略的字段默认为 `nil`。需要注入内置参数时可使用该构造器。显式指定状态，查询时才能识别该绑定。

## 示例

保存显式值及其输入状态。

```lisp
(let ((binding
        (han.args:make-arg-binding
         :name "jobs" :value "4" :status :input)))
  (han.args:arg-binding-value binding))
;; => "4"
```

用手工构造的内置绑定给未声明的上下文键提供默认值。

```lisp
(let ((builtins (make-hash-table :test 'equalp)))
  (setf (gethash "mode" builtins)
        (han.args:make-arg-binding :name "mode" :value "batch" :status :default))
  (han.args:get-arg "mode" (han.args:bind-args (han.args:parse-args-spec nil)
                                              (han.args:parse-args-input '("demo")) builtins)))
;; => values ("batch" :default)
```

[`han.args:arg-binding`](arg-binding.zh-CN.md) · [`han.args:arg-binding-value`](arg-binding-value.zh-CN.md) · [`han.args:get-arg`](get-arg.zh-CN.md) · [源码](../../../args/bind.lisp) · [索引](../README.zh-CN.md)
