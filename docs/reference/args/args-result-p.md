# `han.args:args-result-p`

*Predicate · 谓词*

## Syntax · 语法

```text
(han.args:args-result-p object) → generalized-boolean
```

## Description · 说明

Recognize a `args-result` structure. Any Lisp object can be passed. The predicate inspects its type without changing it.

判断传入的 Lisp 对象是否为 `args-result` 结构。只检查对象类型，调用后对象保持原样。

## Examples · 示例

Recognize the final stage of a successful invocation. Compare it with an unrelated keyword. 确认成功绑定后得到的最终结果类型。再与无关关键字作对照。

```lisp
(let ((result
        (han.args:bind-args
         (han.args:parse-args-spec (list (han.args:parse-arg-spec "(--/-j)jobs=1")))
         (han.args:parse-args-input '("demo" "-j" "4")))))
  (list (han.args:args-result-p result) (han.args:args-result-p :unparsed)))
;; => (t nil)
```

Query only the completed step of an invocation. 接收不同阶段的记录时，只查询已绑定的结果。

```lisp
(let* ((input (han.args:parse-args-input '("demo" "-v")))
       (spec (han.args:parse-args-spec (list (han.args:parse-arg-spec "(-v)verbose?"))))
       (done (han.args:bind-args spec input)))
  (mapcar (lambda (x)
            (if (han.args:args-result-p x) (han.args:get-arg "verbose" x) :pending))
          (list input done)))
;; => (:pending t)
```

[`han.args:args-result`](args-result.md) · [`han.args:bind-args`](bind-args.md) · [Source · 源码](../../../args/bind.lisp) · [Index · 索引](../README.md)
