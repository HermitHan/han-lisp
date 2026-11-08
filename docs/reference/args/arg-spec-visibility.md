# `han.args:arg-spec-visibility`

*Accessor · 访问器*

## Syntax · 语法

```text
(han.args:arg-spec-visibility spec) → keyword
(setf (han.args:arg-spec-visibility spec) new-value) → new-value
```

## Description · 说明

Return `:public` or `:hidden`. A `%` prefix marks a declaration as hidden. Help generators can read this metadata when choosing which arguments to display.

返回 `:public` 或 `:hidden`。规格前缀 `%` 表示隐藏。编写帮助生成器时，可以用此字段选择需要展示的参数。

## Examples · 示例

Read the visibility of a hidden setting. 读取隐藏设置的可见性。

```lisp
(let ((spec (han.args:parse-arg-spec "%mode=brief")))
  (han.args:arg-spec-visibility spec))
;; => :hidden
```

Choose declarations for public help. 用可见性筛出应出现在公开帮助里的声明。

```lisp
(mapcar #'han.args:arg-spec-name
        (remove-if-not
         (lambda (decl) (eq (han.args:arg-spec-visibility decl) :public))
         (mapcar #'han.args:parse-arg-spec '("(--)name" "%mode=quiet"))))
;; => ("name")
```

[`han.args:arg-spec`](arg-spec.md) · [`han.args:parse-arg-spec`](parse-arg-spec.md) · [Source · 源码](../../../args/spec.lisp) · [Index · 索引](../README.md)
