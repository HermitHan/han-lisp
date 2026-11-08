# `han.args:arg-diagnostic-code`

*Accessor · 访问器*

## Syntax · 语法

```text
(han.args:arg-diagnostic-code diagnostic) → keyword or nil
(setf (han.args:arg-diagnostic-code diagnostic) new-value) → new-value
```

## Description · 说明

Return the machine-readable identifier when supplied. The binder uses codes such as `:missing-required`, `:missing-option-value`, and `:conflict`. Lexer warnings currently leave this field `nil`.

返回可用于程序判断的诊断码。绑定器会给出 `:missing-required`、`:missing-option-value`、`:conflict` 等代码；词法警告当前会将此字段留为 `nil`。

## Examples · 示例

Branch on an absent required field. 按诊断码判断是否缺少必需参数。

```lisp
(let ((diagnostic
        (first
         (han.args:args-result-diagnostics
          (han.args:bind-args
           (han.args:parse-args-spec (list (han.args:parse-arg-spec "!(--)input")))
           (han.args:parse-args-input '("demo")))))))
  (han.args:arg-diagnostic-code diagnostic))
;; => :missing-required
```

Inspect a lexer warning without a machine-readable code. 词法警告可能没有诊断码；此时仍可读取其严重程度。

```lisp
(let ((input
        (han.args:parse-args-input '("demo" "--"))))
  (let ((warning (first (han.args:args-input-diagnostics input))))
    (values (han.args:arg-diagnostic-kind warning)
            (han.args:arg-diagnostic-code warning))))
;; => values (:warning nil)
```

[`han.args:arg-diagnostic`](arg-diagnostic.md) · [`han.args:args-result-diagnostics`](args-result-diagnostics.md) · [Source · 源码](../../../args/lexer.lisp) · [Index · 索引](../README.md)
