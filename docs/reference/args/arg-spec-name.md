# `han.args:arg-spec-name`

*Accessor · 访问器*

## Syntax · 语法

```text
(han.args:arg-spec-name spec) → string or integer
(setf (han.args:arg-spec-name spec) new-value) → new-value
```

## Description · 说明

Return the key used to store and query this argument. Named arguments use strings, while a positional declaration such as `$2` uses the integer `2`.

返回存储和查询该参数时使用的键。命名参数使用字符串，`$2` 等位置声明使用整数键 `2`。

## Examples · 示例

Retrieve the lookup key behind two option spellings. 读取长短两个选项共同指向的查询键。

```lisp
(let ((spec (han.args:parse-arg-spec "!(--/-j)jobs")))
  (han.args:arg-spec-name spec))
;; => "jobs"
```

Look up positional declarations using an integer key. 位置声明以整数为查询键。

```lisp
(han.args:arg-spec-name (han.args:parse-arg-spec "$2"))
;; => 2
```

[`han.args:arg-spec`](arg-spec.md) · [`han.args:parse-arg-spec`](parse-arg-spec.md) · [Source · 源码](../../../args/spec.lisp) · [Index · 索引](../README.md)
