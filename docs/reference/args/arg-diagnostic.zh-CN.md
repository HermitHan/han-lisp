# `han.args:arg-diagnostic`

[English](arg-diagnostic.md)

*结构类型*

## 语法

```text
han.args:arg-diagnostic
(typep object 'han.args:arg-diagnostic) → generalized-boolean
```

## 说明

一条输入警告或错误。应用程序可以读取严重程度、诊断码、说明和可选位置，决定是否继续。

## 示例

核对可疑 token 写法所产生的诊断记录类型。

```lisp
(let ((diagnostic
        (first (han.args:args-input-diagnostics
                (han.args:parse-args-input '("demo" "--"))))))
  (typep diagnostic 'han.args:arg-diagnostic))
;; => t
```

同时展示程序自己的进度消息和分析器生成的诊断。

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

[`han.args:arg-diagnostic-p`](arg-diagnostic-p.zh-CN.md) · [`han.args:make-arg-diagnostic`](make-arg-diagnostic.zh-CN.md) · [`han.args:args-result-diagnostics`](args-result-diagnostics.zh-CN.md) · [源码](../../../args/lexer.lisp) · [索引](../README.zh-CN.md)
