# `han.args:arg-key-equal`

*Function · 函数*

## Syntax · 语法

```text
(han.args:arg-key-equal x y) → generalized-boolean
```

## Description · 说明

Compare two string keys case-insensitively with `string-equal`. For other pairs use `eql`. This supports named arguments and positional integers while preserving the distinction between the integer `1` and the string `"1"`.

比较两个字符串键时使用忽略大小写的 `string-equal`；其他情形按 `eql` 比较。命名参数与位置整数都可用作键，整数 `1` 和字符串 `"1"` 是两个不同的键。

## Examples · 示例

Compare names and numeric positions directly. 分别比较名称与位置编号。

```lisp
(list (han.args:arg-key-equal "Jobs" "jobs")
      (han.args:arg-key-equal 1 1)
      (han.args:arg-key-equal 1 "1"))
;; => (t t nil)
```

Use the same comparison when searching a mixture of names and positions. 在混合名称和位置编号的集合中沿用同一种查找规则。

```lisp
(list (position "NAME" '(0 "name" "file") :test #'han.args:arg-key-equal)
      (position "0" '(0 "name" "file") :test #'han.args:arg-key-equal))
;; => (1 nil)
```

[`han.args:arg-spec-name`](arg-spec-name.md) · [`han.args:parse-args-spec`](parse-args-spec.md) · [Source · 源码](../../../args/spec.lisp) · [Index · 索引](../README.md)
