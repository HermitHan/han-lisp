# `han.args:parse-arg-spec`

*Function · 函数*

## Syntax · 语法

```text
(han.args:parse-arg-spec spec-string) → arg-spec
```

## Description · 说明

Parse a single declaration string. The return value records lookup name, long/short/slot spellings, arity, requirement, visibility, and default expression. Malformed syntax, a mixed slot/option declaration, or an invalid default reference can signal an error while building the command specification.

解析一条声明字符串，返回的结构记录查询名、长短选项或槽的入口、参数形态、必需性、可见性及默认表达式。构建命令规格时，格式无效、同时声明槽和选项或默认引用格式错误，都可能触发错误。

## Examples · 示例

Expand short and long aliases while retaining a literal default. 展开长短选项并读取保留的字面默认值。

```lisp
(let ((spec (han.args:parse-arg-spec "(--/-)jobs=4")))
  (list (han.args:arg-spec-name spec)
        (han.args:arg-spec-short-entry spec)
        (han.args:arg-spec-default spec)))
;; => ("jobs" "-j" "4")
```

Inspect a default assembled from a field reference and a suffix. 查看由字段引用和后缀拼成的默认表达式。

```lisp
(han.args:arg-spec-default (han.args:parse-arg-spec "out=@{name}.txt"))
;; => (:concat (:query "name") ".txt")
```

Reject an unclosed reference in a default. 默认值中带花括号的引用必须闭合。

```lisp
(han.args:parse-arg-spec "out=@{name")
;; signals simple-error
```

Treat a positional declaration as required. 查询位置声明的整数编号以及必需性。

```lisp
(let ((spec
        (han.args:parse-arg-spec "$0")))
  (values (han.args:arg-spec-name spec) (han.args:arg-spec-required spec)))
;; => values (0 t)
```

[`han.args:arg-spec`](arg-spec.md) · [`han.args:parse-args-spec`](parse-args-spec.md) · [Source · 源码](../../../args/spec.lisp) · [Index · 索引](../README.md)
