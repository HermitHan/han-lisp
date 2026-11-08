# `han.args:arg-binding-p`

*Predicate · 谓词*

## Syntax · 语法

```text
(han.args:arg-binding-p object) → generalized-boolean
```

## Description · 说明

Recognize a `arg-binding` structure. Any Lisp object can be passed. The predicate inspects its type without changing it.

判断传入的 Lisp 对象是否为 `arg-binding` 结构。只检查对象类型，调用后对象保持原样。

## Examples · 示例

Recognize one value record returned from a binding table. Compare it with an unrelated keyword. 确认从绑定表取得的是参数值记录。再与无关关键字作对照。

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

Distinguish a known absent option from an unregistered key. 从哈希表中区分已声明但未出现的选项和未声明的查询名。

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

[`han.args:arg-binding`](arg-binding.md) · [`han.args:get-arg`](get-arg.md) · [Source · 源码](../../../args/bind.lisp) · [Index · 索引](../README.md)
