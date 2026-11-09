# `han.args:arg-spec-name`

[English](arg-spec-name.md)

*访问器*

## 语法

```text
(han.args:arg-spec-name spec) → string or integer
(setf (han.args:arg-spec-name spec) new-value) → new-value
```

## 说明

返回存储和查询该参数时使用的键。命名参数使用字符串，`$2` 等位置声明使用整数键 `2`。

## 示例

读取长短两个选项共同指向的查询键。

```lisp
(let ((spec (han.args:parse-arg-spec "!(--/-j)jobs")))
  (han.args:arg-spec-name spec))
;; => "jobs"
```

位置声明以整数为查询键。

```lisp
(han.args:arg-spec-name (han.args:parse-arg-spec "$2"))
;; => 2
```

[`han.args:arg-spec`](arg-spec.zh-CN.md) · [`han.args:parse-arg-spec`](parse-arg-spec.zh-CN.md) · [源码](../../../args/spec.lisp) · [索引](../README.zh-CN.md)
