# `han.args:args-result-spec`

[English](args-result-spec.md)

*访问器*

## 语法

```text
(han.args:args-result-spec result) → args-spec
(setf (han.args:args-result-spec result) new-value) → new-value
```

## 说明

返回本次调用 `bind-args` 时传入的命令规格。它的规格表保存此次绑定使用的全部参数声明。

## 示例

从绑定结果取回规格的命令标签。

```lisp
(let ((result
        (han.args:bind-args
         (han.args:parse-args-spec (list (han.args:parse-arg-spec "(--/-j)jobs=1")))
         (han.args:parse-args-input '("demo" "-j" "4")))))
  (han.args:args-spec-command (han.args:args-result-spec result)))
;; => "my-args"
```

同一份规格可用于多次绑定，结果保留原规格对象。

```lisp
(let ((specs
        (han.args:parse-args-spec
         (mapcar #'han.args:parse-arg-spec '("(--)jobs=1")))))
  (eq specs (han.args:args-result-spec
             (han.args:bind-args specs (han.args:parse-args-input '("demo"))))))
;; => t
```

[`han.args:args-result`](args-result.zh-CN.md) · [`han.args:bind-args`](bind-args.zh-CN.md) · [源码](../../../args/bind.lisp) · [索引](../README.zh-CN.md)
