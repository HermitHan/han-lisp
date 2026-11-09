# `han.args:make-args-result`

[English](make-args-result.md)

*构造器*

## 语法

```text
(han.args:make-args-result &key spec input builtin-bindings bindings diagnostics) → han.args:args-result
```

## 说明

根据给定的关键字字段创建并返回新的 `args-result` 对象。省略的字段默认为 `nil`。手工组装可供查询的对象时应提供两个绑定表；通常由 `bind-args` 生成完整结果。

## 示例

为空命令规格手工构建结果对象。

```lisp
(let ((result
        (han.args:make-args-result
         :spec (han.args:parse-args-spec nil)
          :input (han.args:parse-args-input '("demo"))
          :builtin-bindings (make-hash-table :test 'equalp)
          :bindings (make-hash-table :test 'equalp))))
  (han.args:args-result-diagnostics result))
;; => nil
```

已有绑定表时可组装查询结果，直接读取其中的值与状态。

```lisp
(let ((bindings (make-hash-table :test 'equalp)))
  (setf (gethash "jobs" bindings)
        (han.args:make-arg-binding :name "jobs" :value "4" :status :input))
  (han.args:get-arg "jobs"
                    (han.args:make-args-result :bindings bindings
                                               :builtin-bindings (make-hash-table))))
;; => values ("4" :input)
```

[`han.args:args-result`](args-result.zh-CN.md) · [`han.args:args-result-diagnostics`](args-result-diagnostics.zh-CN.md) · [`han.args:bind-args`](bind-args.zh-CN.md) · [源码](../../../args/bind.lisp) · [索引](../README.zh-CN.md)
