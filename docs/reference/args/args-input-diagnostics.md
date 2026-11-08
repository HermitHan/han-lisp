# `han.args:args-input-diagnostics`

*Accessor · 访问器*

## Syntax · 语法

```text
(han.args:args-input-diagnostics input) → list of arg-diagnostic
(setf (han.args:args-input-diagnostics input) new-value) → new-value
```

## Description · 说明

Return diagnostics from tokenization. A spelling such as a standalone `--` is retained as a value and also reported here. Binding carries these diagnostics into the result.

返回词法阶段的诊断。例如独立的 `--` 会保留为普通值，同时在这里记录警告。绑定阶段会把这些诊断带入结果。

## Examples · 示例

Inspect the lexer warning on a bare double dash. 查看单独两个短横线带来的词法警告。

```lisp
(let ((input (han.args:parse-args-input '("demo" "--"))))
  (mapcar #'han.args:arg-diagnostic-kind (han.args:args-input-diagnostics input)))
;; => (:warning)
```

A syntactically valid option can still be undeclared at binding time. 格式正常但未声明的选项要到绑定阶段才会被报告。

```lisp
(let ((input
        (han.args:parse-args-input '("demo" "--unknown"))))
  (let ((result (han.args:bind-args (han.args:parse-args-spec nil) input)))
    (values (han.args:args-input-diagnostics input)
            (mapcar #'han.args:arg-diagnostic-code
                    (han.args:args-result-diagnostics result)))))
;; => values (nil (:undefined-option))
```

[`han.args:args-input`](args-input.md) · [`han.args:parse-args-input`](parse-args-input.md) · [Source · 源码](../../../args/lexer.lisp) · [Index · 索引](../README.md)
