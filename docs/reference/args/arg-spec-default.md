# `han.args:arg-spec-default`

*Accessor · 访问器*

## Syntax · 语法

```text
(han.args:arg-spec-default spec) → string, expression or nil
(setf (han.args:arg-spec-default spec) new-value) → new-value
```

## Description · 说明

Return the parsed default before reference evaluation. Literal defaults are strings, a reference is a `(:query name)` form, and text with embedded references is a `(:concat ...)` form. `get-arg` resolves these forms on lookup.

返回引用尚未求值的默认值。字面默认值是字符串，单个引用为 `(:query name)`，带内嵌引用的文本为 `(:concat ...)`。`get-arg` 查询时会解析这些表达式。

## Examples · 示例

Inspect a default before resolving an interpolated name. 在解析引用前查看含插值的默认表达式。

```lisp
(let ((spec (han.args:parse-arg-spec "log=@{name}.log")))
  (han.args:arg-spec-default spec))
;; => (:concat (:query "name") ".log")
```

Distinguish a literal default from a query and an absent default. 区分字面默认值、引用表达式以及没有默认值三种声明。

```lisp
(mapcar (lambda (decl)
          (han.args:arg-spec-default (han.args:parse-arg-spec decl)))
        '("a=4" "b=@a" "c"))
;; => ("4" (:query "a") nil)
```

[`han.args:arg-spec`](arg-spec.md) · [`han.args:parse-arg-spec`](parse-arg-spec.md) · [Source · 源码](../../../args/spec.lisp) · [Index · 索引](../README.md)
