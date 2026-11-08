# `han.args:arg-diagnostic-message`

*Accessor · 访问器*

## Syntax · 语法

```text
(han.args:arg-diagnostic-message diagnostic) → string
(setf (han.args:arg-diagnostic-message diagnostic) new-value) → new-value
```

## Description · 说明

Return the diagnostic's human-readable explanation. For branching on a particular failure, use the code when one is available.

返回供人阅读的诊断文字。程序要区分具体错误时，可以优先读取该诊断附带的代码。

## Examples · 示例

Read the explanation for a suspicious double dash. 取得对独立双短横线的解释。

```lisp
(let ((diagnostic
        (first (han.args:args-input-diagnostics
                (han.args:parse-args-input '("demo" "--"))))))
  (han.args:arg-diagnostic-message diagnostic))
;; => "Only --, no name, missed?"
```

Display an explanation for a missing required output. 向用户说明哪个必需选项缺失。

```lisp
(let ((result
        (han.args:bind-args
         (han.args:parse-args-spec
          (mapcar #'han.args:parse-arg-spec '("!(--)output")))
         (han.args:parse-args-input '("demo")))))
  (han.args:arg-diagnostic-message
   (first (han.args:args-result-diagnostics result))))
;; => "Required argument output is missing."
```

[`han.args:arg-diagnostic`](arg-diagnostic.md) · [`han.args:args-result-diagnostics`](args-result-diagnostics.md) · [Source · 源码](../../../args/lexer.lisp) · [Index · 索引](../README.md)
