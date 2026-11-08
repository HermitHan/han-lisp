# `han.args:arg-binding`

*Structure type · 结构类型*

## Syntax · 语法

```text
han.args:arg-binding
(typep object 'han.args:arg-binding) → generalized-boolean
```

## Description · 说明

The value and status assigned to one lookup name. A default expression may remain in the value slot until a query resolves its references.

一个查询名对应的值及绑定状态。默认表达式可以暂存在值字段中，直到查询时才解析其中的引用。

## Examples · 示例

Recognize one value record returned from a binding table. 确认从绑定表取得的是参数值记录。

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

Format the status of a successful lookup and a key with no binding. 分别格式化已注册绑定的状态和没有绑定的键。

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

[`han.args:arg-binding-p`](arg-binding-p.md) · [`han.args:make-arg-binding`](make-arg-binding.md) · [`han.args:get-arg`](get-arg.md) · [Source · 源码](../../../args/bind.lisp) · [Index · 索引](../README.md)
