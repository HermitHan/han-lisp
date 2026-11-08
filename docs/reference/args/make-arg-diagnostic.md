# `han.args:make-arg-diagnostic`

*Constructor · 构造器*

## Syntax · 语法

```text
(han.args:make-arg-diagnostic &key kind code message position) → han.args:arg-diagnostic
```

## Description · 说明

Construct and return a fresh `arg-diagnostic` with the supplied keyword fields. Omitted fields default to `nil`. Use `:error` or `:warning` as the severity and set a position only when an input token provides a location.

根据给定的关键字字段创建并返回新的 `arg-diagnostic` 对象。省略的字段默认为 `nil`。严重程度可以用 `:error` 或 `:warning`，输入 token 可以定位时再设置位置。

## Examples · 示例

Attach an explanation and position to an application warning. 给应用警告记录说明和位置。

```lisp
(let ((diagnostic
        (han.args:make-arg-diagnostic
         :kind :warning :code :unused-option :message "Extra filename" :position 2)))
  (han.args:arg-diagnostic-code diagnostic))
;; => :unused-option
```

Create a diagnostic for an error without a token location. 创建没有输入位置的业务诊断，并检查未指定字段的默认值。

```lisp
(let ((item (han.args:make-arg-diagnostic :kind :error :message "No output selected")))
  (values (han.args:arg-diagnostic-kind item)
          (han.args:arg-diagnostic-code item)
          (han.args:arg-diagnostic-position item)))
;; => values (:error nil nil)
```

[`han.args:arg-diagnostic`](arg-diagnostic.md) · [`han.args:arg-diagnostic-code`](arg-diagnostic-code.md) · [`han.args:args-result-diagnostics`](args-result-diagnostics.md) · [Source · 源码](../../../args/lexer.lisp) · [Index · 索引](../README.md)
