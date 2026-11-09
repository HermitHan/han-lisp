# `han.args:arg-key-equal`

[English](arg-key-equal.md)

*函数*

## 语法

```text
(han.args:arg-key-equal x y) → generalized-boolean
```

## 说明

比较两个字符串键时使用忽略大小写的 `string-equal`；其他情形按 `eql` 比较。命名参数与位置整数都可用作键，整数 `1` 和字符串 `"1"` 是两个不同的键。

## 示例

分别比较名称与位置编号。

```lisp
(list (han.args:arg-key-equal "Jobs" "jobs")
      (han.args:arg-key-equal 1 1)
      (han.args:arg-key-equal 1 "1"))
;; => (t t nil)
```

在混合名称和位置编号的集合中沿用同一种查找规则。

```lisp
(list (position "NAME" '(0 "name" "file") :test #'han.args:arg-key-equal)
      (position "0" '(0 "name" "file") :test #'han.args:arg-key-equal))
;; => (1 nil)
```

[`han.args:arg-spec-name`](arg-spec-name.zh-CN.md) · [`han.args:parse-args-spec`](parse-args-spec.zh-CN.md) · [源码](../../../args/spec.lisp) · [索引](../README.zh-CN.md)
