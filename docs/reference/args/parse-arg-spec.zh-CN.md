# `han.args:parse-arg-spec`

[English](parse-arg-spec.md)

*函数*

## 语法

```text
(han.args:parse-arg-spec spec-string) → arg-spec
```

## 说明

解析一条声明字符串，返回的结构记录查询名、长短选项或槽的入口、参数形态、必需性、可见性及默认表达式。构建命令规格时，格式无效、同时声明槽和选项或默认引用格式错误，都可能触发错误。

## 示例

展开长短选项并读取保留的字面默认值。

```lisp
(let ((spec (han.args:parse-arg-spec "(--/-)jobs=4")))
  (list (han.args:arg-spec-name spec)
        (han.args:arg-spec-short-entry spec)
        (han.args:arg-spec-default spec)))
;; => ("jobs" "-j" "4")
```

查看由字段引用和后缀拼成的默认表达式。

```lisp
(han.args:arg-spec-default (han.args:parse-arg-spec "out=@{name}.txt"))
;; => (:concat (:query "name") ".txt")
```

默认值中带花括号的引用必须闭合。

```lisp
(han.args:parse-arg-spec "out=@{name")
;; signals simple-error
```

查询位置声明的整数编号以及必需性。

```lisp
(let ((spec
        (han.args:parse-arg-spec "$0")))
  (values (han.args:arg-spec-name spec) (han.args:arg-spec-required spec)))
;; => values (0 t)
```

[`han.args:arg-spec`](arg-spec.zh-CN.md) · [`han.args:parse-args-spec`](parse-args-spec.zh-CN.md) · [源码](../../../args/spec.lisp) · [索引](../README.zh-CN.md)
