# `han.args:args-input-diagnostics`

[English](args-input-diagnostics.md)

*访问器*

## 语法

```text
(han.args:args-input-diagnostics input) → list of arg-diagnostic
(setf (han.args:args-input-diagnostics input) new-value) → new-value
```

## 说明

返回词法阶段的诊断。例如独立的 `--` 会保留为普通值，同时在这里记录警告。绑定阶段会把这些诊断带入结果。

## 示例

查看单独两个短横线带来的词法警告。

```lisp
(let ((input (han.args:parse-args-input '("demo" "--"))))
  (mapcar #'han.args:arg-diagnostic-kind (han.args:args-input-diagnostics input)))
;; => (:warning)
```

格式正常但未声明的选项要到绑定阶段才会被报告。

```lisp
(let ((input
        (han.args:parse-args-input '("demo" "--unknown"))))
  (let ((result (han.args:bind-args (han.args:parse-args-spec nil) input)))
    (values (han.args:args-input-diagnostics input)
            (mapcar #'han.args:arg-diagnostic-code
                    (han.args:args-result-diagnostics result)))))
;; => values (nil (:undefined-option))
```

[`han.args:args-input`](args-input.zh-CN.md) · [`han.args:parse-args-input`](parse-args-input.zh-CN.md) · [源码](../../../args/lexer.lisp) · [索引](../README.zh-CN.md)
