# `han.args:args-spec-args-table`

*Accessor · 访问器*

## Syntax · 语法

```text
(han.args:args-spec-args-table specs) → hash table
(setf (han.args:args-spec-args-table specs) new-value) → new-value
```

## Description · 说明

Return the table of declarations keyed by lookup name. `parse-args-spec` builds an `equalp` table, so a string key can be queried with different letter case. Values are `arg-spec` records.

返回按查询名索引的参数规格表。`parse-args-spec` 构建的表使用 `equalp`，字符串键可以忽略大小写查询。表值是 `arg-spec` 记录。

## Examples · 示例

Find a declaration with differently cased input. 用不同大小写的名称查找同一声明。

```lisp
(let ((specs
        (han.args:parse-args-spec
         (list (han.args:parse-arg-spec "(--/-j)jobs=1")) "report")))
  (han.args:arg-spec-long-entry (gethash "JOBS" (han.args:args-spec-args-table specs))))
;; => "--jobs"
```

Read positional declarations by integer key. 在同一张规格表中按整数键查位置参数。

```lisp
(let ((specs
        (han.args:parse-args-spec
         (mapcar #'han.args:parse-arg-spec '("$1" "(--)mode")))))
  (han.args:arg-spec-arity (gethash 1 (han.args:args-spec-args-table specs))))
;; => :position
```

[`han.args:args-spec`](args-spec.md) · [`han.args:parse-args-spec`](parse-args-spec.md) · [Source · 源码](../../../args/spec.lisp) · [Index · 索引](../README.md)
