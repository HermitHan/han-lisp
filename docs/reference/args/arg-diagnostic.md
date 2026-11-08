# `han.args:arg-diagnostic`

*Structure type · 结构类型*

## Syntax · 语法

```text
han.args:arg-diagnostic
(typep object 'han.args:arg-diagnostic) → generalized-boolean
```

## Description · 说明

A warning or error about input. Applications can inspect its severity, code, message, and optional location, then decide whether to continue.

一条输入警告或错误。应用程序可以读取严重程度、诊断码、说明和可选位置，决定是否继续。

## Examples · 示例

Check the record generated for a token spelling warning. 核对可疑 token 写法所产生的诊断记录类型。

```lisp
(let ((diagnostic
        (first (han.args:args-input-diagnostics
                (han.args:parse-args-input '("demo" "--"))))))
  (typep diagnostic 'han.args:arg-diagnostic))
;; => t
```

Render a diagnostic alongside a caller-provided progress message. 同时展示程序自己的进度消息和分析器生成的诊断。

```lisp
(let ((events (list "reading"
                    (han.args:make-arg-diagnostic :kind :warning :message "unknown option"))))
  (mapcar (lambda (event)
            (etypecase event
              (string event)
              (han.args:arg-diagnostic (han.args:arg-diagnostic-message event))))
          events))
;; => ("reading" "unknown option")
```

[`han.args:arg-diagnostic-p`](arg-diagnostic-p.md) · [`han.args:make-arg-diagnostic`](make-arg-diagnostic.md) · [`han.args:args-result-diagnostics`](args-result-diagnostics.md) · [Source · 源码](../../../args/lexer.lisp) · [Index · 索引](../README.md)
