# `han.args:arg-spec-arity`

[English](arg-spec-arity.md)

*访问器*

## 语法

```text
(han.args:arg-spec-arity spec) → keyword
(setf (han.args:arg-spec-arity spec) new-value) → new-value
```

## 说明

返回绑定方式。`:single` 取一个值，`:flag` 记录是否出现，`:block` 收集一段 token，`:position` 取得未被选项消耗的位置值。

## 示例

识别接收单个值的选项规格。

```lisp
(let ((spec (han.args:parse-arg-spec "!(--/-j)jobs")))
  (han.args:arg-spec-arity spec))
;; => :single
```

编写帮助时可按参数的形态分别展示。

```lisp
(mapcar (lambda (decl)
          (han.args:arg-spec-arity (han.args:parse-arg-spec decl)))
        '("(--)name" "(--/-v)verbose?" "(@:)files" "$1"))
;; => (:single :flag :block :position)
```

[`han.args:arg-spec`](arg-spec.zh-CN.md) · [`han.args:parse-arg-spec`](parse-arg-spec.zh-CN.md) · [源码](../../../args/spec.lisp) · [索引](../README.zh-CN.md)
