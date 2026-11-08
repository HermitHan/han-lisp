# `han.args:arg-diagnostic-position`

*Accessor · 访问器*

## Syntax · 语法

```text
(han.args:arg-diagnostic-position diagnostic) → nonnegative integer or nil
(setf (han.args:arg-diagnostic-position diagnostic) new-value) → new-value
```

## Description · 说明

Return the zero-based token index after the command name, if the diagnostic refers to an input token. A missing declaration value may have no input position.

返回诊断所指 token 在命令名之后的零基索引。必需参数完全没有出现时，可以没有对应输入位置。

## Examples · 示例

Locate a lexer warning in the original input. 定位词法警告在原始输入中的位置。

```lisp
(let ((diagnostic
        (first (han.args:args-input-diagnostics
                (han.args:parse-args-input '("demo" "--"))))))
  (han.args:arg-diagnostic-position diagnostic))
;; => 0
```

Handle an absent argument with no corresponding token. 必需参数完全没有出现时，诊断无法指向具体 token。

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

[`han.args:arg-diagnostic`](arg-diagnostic.md) · [`han.args:args-result-diagnostics`](args-result-diagnostics.md) · [Source · 源码](../../../args/lexer.lisp) · [Index · 索引](../README.md)
