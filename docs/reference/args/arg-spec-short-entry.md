# `han.args:arg-spec-short-entry`

*Accessor · 访问器*

## Syntax · 语法

```text
(han.args:arg-spec-short-entry spec) → string or nil
(setf (han.args:arg-spec-short-entry spec) new-value) → new-value
```

## Description · 说明

Return the declared short option, including its leading dash. This spelling can be used to supply the same binding as the long option. It is `nil` when omitted.

返回包含前导短横线的短选项。同一个参数可以通过该入口或长选项提供值。没有声明短选项时为 `nil`。

## Examples · 示例

Read an explicitly declared short spelling. 读取明确指定的短选项。

```lisp
(let ((spec (han.args:parse-arg-spec "!(--/-j)jobs")))
  (han.args:arg-spec-short-entry spec))
;; => "-j"
```

Derive the short option from the first letter of its name. 让短选项使用参数名的首字母。

```lisp
(han.args:arg-spec-short-entry (han.args:parse-arg-spec "(-)threads"))
;; => "-t"
```

[`han.args:arg-spec`](arg-spec.md) · [`han.args:parse-arg-spec`](parse-arg-spec.md) · [Source · 源码](../../../args/spec.lisp) · [Index · 索引](../README.md)
