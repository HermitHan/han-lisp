# `han.args:arg-spec-slot-entry`

*Accessor · 访问器*

## Syntax · 语法

```text
(han.args:arg-spec-slot-entry spec) → string or nil
(setf (han.args:arg-spec-slot-entry spec) new-value) → new-value
```

## Description · 说明

Return a block's switch spelling, including `@` and the final `:`. The shorthand `(@:)filter` declares `@filter:`. Ordinary options have `nil` here.

返回块的入口字符串，保留 `@` 和末尾的 `:`。简写 `(@:)filter` 声明的是 `@filter:`；普通选项在此字段上为 `nil`。

## Examples · 示例

Expand a slot shorthand from its lookup name. 用查询名展开槽入口的简写。

```lisp
(let ((spec (han.args:parse-arg-spec "(@:)filter")))
  (han.args:arg-spec-slot-entry spec))
;; => "@filter:"
```

Keep a public slot spelling independent of the lookup name. 命令行槽名和程序内部查询名可以分别指定。

```lisp
(let ((spec
        (han.args:parse-arg-spec "(@next:)filter")))
  (values (han.args:arg-spec-name spec) (han.args:arg-spec-slot-entry spec)))
;; => values ("filter" "@next:")
```

[`han.args:arg-spec`](arg-spec.md) · [`han.args:parse-arg-spec`](parse-arg-spec.md) · [Source · 源码](../../../args/spec.lisp) · [Index · 索引](../README.md)
