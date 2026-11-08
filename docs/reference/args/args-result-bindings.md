# `han.args:args-result-bindings`

*Accessor · 访问器*

## Syntax · 语法

```text
(han.args:args-result-bindings result) → hash table
(setf (han.args:args-result-bindings result) new-value) → new-value
```

## Description · 说明

Return the `equalp` table of ordinary bindings, keyed by argument name or position. Inspect each `arg-binding` for the raw value, originating declaration, and binder status.

返回存放普通绑定的 `equalp` 哈希表，键为参数名称或位置编号。取得 `arg-binding` 后可检查原始值、对应声明及绑定状态。

## Examples · 示例

Read a raw binding by its canonical name. 按标准查询名取得普通绑定。

```lisp
(let ((result
        (han.args:bind-args
         (han.args:parse-args-spec (list (han.args:parse-arg-spec "(--/-j)jobs=1")))
         (han.args:parse-args-input '("demo" "-j" "4")))))
  (han.args:arg-binding-value (gethash "jobs" (han.args:args-result-bindings result))))
;; => "4"
```

Find the binding record of an absent flag. 开关缺省时，绑定表仍保留该声明的记录。

```lisp
(let ((result
        (han.args:bind-args
         (han.args:parse-args-spec
          (mapcar #'han.args:parse-arg-spec '("(--)verbose?")))
         (han.args:parse-args-input '("demo")))))
  (multiple-value-bind (binding found-p)
      (gethash "verbose" (han.args:args-result-bindings result))
    (values found-p (han.args:arg-binding-status binding))))
;; => values (t :missing)
```

[`han.args:args-result`](args-result.md) · [`han.args:bind-args`](bind-args.md) · [Source · 源码](../../../args/bind.lisp) · [Index · 索引](../README.md)
