# `han.args:arg-diagnostic-kind`

[English](arg-diagnostic-kind.md)

*访问器*

## 语法

```text
(han.args:arg-diagnostic-kind diagnostic) → keyword
(setf (han.args:arg-diagnostic-kind diagnostic) new-value) → new-value
```

## 说明

返回这条诊断的严重程度，即 `:warning` 或 `:error`。应用判断是否继续执行时可据此筛选。

## 示例

辨认关于可疑输入的警告。

```lisp
(let ((diagnostic
        (first (han.args:args-input-diagnostics
                (han.args:parse-args-input '("demo" "--"))))))
  (han.args:arg-diagnostic-kind diagnostic))
;; => :warning
```

必需参数缺失会在绑定结果中产生错误级别的诊断。

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

[`han.args:arg-diagnostic`](arg-diagnostic.zh-CN.md) · [`han.args:args-result-diagnostics`](args-result-diagnostics.zh-CN.md) · [源码](../../../args/lexer.lisp) · [索引](../README.zh-CN.md)
