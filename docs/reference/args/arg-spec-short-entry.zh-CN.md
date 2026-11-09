# `han.args:arg-spec-short-entry`

[English](arg-spec-short-entry.md)

*访问器*

## 语法

```text
(han.args:arg-spec-short-entry spec) → string or nil
(setf (han.args:arg-spec-short-entry spec) new-value) → new-value
```

## 说明

返回包含前导短横线的短选项。同一个参数可以通过该入口或长选项提供值。没有声明短选项时为 `nil`。

## 示例

读取明确指定的短选项。

```lisp
(let ((spec (han.args:parse-arg-spec "!(--/-j)jobs")))
  (han.args:arg-spec-short-entry spec))
;; => "-j"
```

让短选项使用参数名的首字母。

```lisp
(han.args:arg-spec-short-entry (han.args:parse-arg-spec "(-)threads"))
;; => "-t"
```

[`han.args:arg-spec`](arg-spec.zh-CN.md) · [`han.args:parse-arg-spec`](parse-arg-spec.zh-CN.md) · [源码](../../../args/spec.lisp) · [索引](../README.zh-CN.md)
