# `han.args:arg-diagnostic-kind`

*Accessor · 访问器*

## Syntax · 语法

```text
(han.args:arg-diagnostic-kind diagnostic) → keyword
(setf (han.args:arg-diagnostic-kind diagnostic) new-value) → new-value
```

## Description · 说明

Return the severity, `:warning` or `:error`, of this diagnostic. Filter by kind when deciding whether the command can proceed.

返回这条诊断的严重程度，即 `:warning` 或 `:error`。应用判断是否继续执行时可据此筛选。

## Examples · 示例

Recognize a warning about a suspicious token. 辨认关于可疑输入的警告。

```lisp
(let ((diagnostic
        (first (han.args:args-input-diagnostics
                (han.args:parse-args-input '("demo" "--"))))))
  (han.args:arg-diagnostic-kind diagnostic))
;; => :warning
```

Inspect the severity of an omitted required argument. 必需参数缺失会在绑定结果中产生错误级别的诊断。

```lisp
(let ((result
        (han.args:bind-args
         (han.args:parse-args-spec
          (mapcar #'han.args:parse-arg-spec '("!(--)output")))
         (han.args:parse-args-input '("demo")))))
  (mapcar #'han.args:arg-diagnostic-kind
          (han.args:args-result-diagnostics result)))
;; => (:error)
```

[`han.args:arg-diagnostic`](arg-diagnostic.md) · [`han.args:args-result-diagnostics`](args-result-diagnostics.md) · [Source · 源码](../../../args/lexer.lisp) · [Index · 索引](../README.md)
