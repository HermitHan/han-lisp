# `han.args:arg-spec-long-entry`

[English](arg-spec-long-entry.md)

*访问器*

## 语法

```text
(han.args:arg-spec-long-entry spec) → string or nil
(setf (han.args:arg-spec-long-entry spec) new-value) → new-value
```

## 说明

返回含前导 `--` 的长选项写法。规格中的简写 `--` 会展开为该参数的全名；没有声明长选项时为 `nil`。

## 示例

查看按参数名自动展开的长选项。

```lisp
(let ((spec (han.args:parse-arg-spec "!(--/-j)jobs")))
  (han.args:arg-spec-long-entry spec))
;; => "--jobs"
```

只声明短选项时，可以判断长入口是否存在。

```lisp
(han.args:arg-spec-long-entry (han.args:parse-arg-spec "(-j)jobs"))
;; => nil
```

[`han.args:arg-spec`](arg-spec.zh-CN.md) · [`han.args:parse-arg-spec`](parse-arg-spec.zh-CN.md) · [源码](../../../args/spec.lisp) · [索引](../README.zh-CN.md)
