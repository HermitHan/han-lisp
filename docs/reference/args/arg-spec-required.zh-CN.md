# `han.args:arg-spec-required`

[English](arg-spec-required.md)

*访问器*

## 语法

```text
(han.args:arg-spec-required spec) → generalized boolean
(setf (han.args:arg-spec-required spec) new-value) → new-value
```

## 说明

返回规格是否要求提供值。绑定时，未能满足的必需参数会产生诊断。单值选项用 `!` 声明必需，开关规格始终为可选。

## 示例

读取带感叹号声明的单值参数的必需性。

```lisp
(let ((spec (han.args:parse-arg-spec "!(--/-j)jobs")))
  (han.args:arg-spec-required spec))
;; => t
```

位置声明需要有值，开关允许缺省，即便其规格带有必需前缀。

```lisp
(mapcar (lambda (decl)
          (han.args:arg-spec-required (han.args:parse-arg-spec decl)))
        '("$1" "!(--/-v)verbose?"))
;; => (t nil)
```

[`han.args:arg-spec`](arg-spec.zh-CN.md) · [`han.args:parse-arg-spec`](parse-arg-spec.zh-CN.md) · [源码](../../../args/spec.lisp) · [索引](../README.zh-CN.md)
