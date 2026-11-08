# `han.args:arg-spec-long-entry`

*Accessor · 访问器*

## Syntax · 语法

```text
(han.args:arg-spec-long-entry spec) → string or nil
(setf (han.args:arg-spec-long-entry spec) new-value) → new-value
```

## Description · 说明

Return the long option spelling, including its leading `--`. A shorthand `--` in the declaration expands to the full argument name. A declaration with no long spelling leaves this field `nil`.

返回含前导 `--` 的长选项写法。规格中的简写 `--` 会展开为该参数的全名；没有声明长选项时为 `nil`。

## Examples · 示例

Inspect an automatically expanded long spelling. 查看按参数名自动展开的长选项。

```lisp
(let ((spec (han.args:parse-arg-spec "!(--/-j)jobs")))
  (han.args:arg-spec-long-entry spec))
;; => "--jobs"
```

Detect whether a short-only declaration has a long spelling. 只声明短选项时，可以判断长入口是否存在。

```lisp
(han.args:arg-spec-long-entry (han.args:parse-arg-spec "(-j)jobs"))
;; => nil
```

[`han.args:arg-spec`](arg-spec.md) · [`han.args:parse-arg-spec`](parse-arg-spec.md) · [Source · 源码](../../../args/spec.lisp) · [Index · 索引](../README.md)
