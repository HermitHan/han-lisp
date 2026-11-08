# `han.args:arg-spec-arity`

*Accessor · 访问器*

## Syntax · 语法

```text
(han.args:arg-spec-arity spec) → keyword
(setf (han.args:arg-spec-arity spec) new-value) → new-value
```

## Description · 说明

Return the binding mode. `:single` consumes a value, `:flag` records presence, `:block` captures a list of tokens, and `:position` selects a free positional value.

返回绑定方式。`:single` 取一个值，`:flag` 记录是否出现，`:block` 收集一段 token，`:position` 取得未被选项消耗的位置值。

## Examples · 示例

Recognize an option that consumes one value. 识别接收单个值的选项规格。

```lisp
(let ((spec (han.args:parse-arg-spec "!(--/-j)jobs")))
  (han.args:arg-spec-arity spec))
;; => :single
```

Dispatch help rendering by the declared binding mode. 编写帮助时可按参数的形态分别展示。

```lisp
(mapcar (lambda (decl)
          (han.args:arg-spec-arity (han.args:parse-arg-spec decl)))
        '("(--)name" "(--/-v)verbose?" "(@:)files" "$1"))
;; => (:single :flag :block :position)
```

[`han.args:arg-spec`](arg-spec.md) · [`han.args:parse-arg-spec`](parse-arg-spec.md) · [Source · 源码](../../../args/spec.lisp) · [Index · 索引](../README.md)
