# `han.args:arg-diagnostic-position`

[English](arg-diagnostic-position.md)

*访问器*

## 语法

```text
(han.args:arg-diagnostic-position diagnostic) → nonnegative integer or nil
(setf (han.args:arg-diagnostic-position diagnostic) new-value) → new-value
```

## 说明

返回诊断所指 token 在命令名之后的零基索引。必需参数完全没有出现时，可以没有对应输入位置。

## 示例

定位词法警告在原始输入中的位置。

```lisp
(let ((diagnostic
        (first (han.args:args-input-diagnostics
                (han.args:parse-args-input '("demo" "--"))))))
  (han.args:arg-diagnostic-position diagnostic))
;; => 0
```

必需参数完全没有出现时，诊断无法指向具体 token。

```lisp
(let ((result
        (han.args:bind-args
         (han.args:parse-args-spec
          (mapcar #'han.args:parse-arg-spec '("!(--)output")))
         (han.args:parse-args-input '("demo")))))
  (let ((d (first (han.args:args-result-diagnostics result))))
    (values (han.args:arg-diagnostic-code d)
            (han.args:arg-diagnostic-position d))))
;; => values (:missing-required nil)
```

[`han.args:arg-diagnostic`](arg-diagnostic.zh-CN.md) · [`han.args:args-result-diagnostics`](args-result-diagnostics.zh-CN.md) · [源码](../../../args/lexer.lisp) · [索引](../README.zh-CN.md)
