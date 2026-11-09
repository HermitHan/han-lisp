# `han.args:arg-spec-visibility`

[English](arg-spec-visibility.md)

*访问器*

## 语法

```text
(han.args:arg-spec-visibility spec) → keyword
(setf (han.args:arg-spec-visibility spec) new-value) → new-value
```

## 说明

返回 `:public` 或 `:hidden`。规格前缀 `%` 表示隐藏。编写帮助生成器时，可以用此字段选择需要展示的参数。

## 示例

读取隐藏设置的可见性。

```lisp
(let ((spec (han.args:parse-arg-spec "%mode=brief")))
  (han.args:arg-spec-visibility spec))
;; => :hidden
```

用可见性筛出应出现在公开帮助里的声明。

```lisp
(mapcar #'han.args:arg-spec-name
        (remove-if-not
         (lambda (decl) (eq (han.args:arg-spec-visibility decl) :public))
         (mapcar #'han.args:parse-arg-spec '("(--)name" "%mode=quiet"))))
;; => ("name")
```

[`han.args:arg-spec`](arg-spec.zh-CN.md) · [`han.args:parse-arg-spec`](parse-arg-spec.zh-CN.md) · [源码](../../../args/spec.lisp) · [索引](../README.zh-CN.md)
