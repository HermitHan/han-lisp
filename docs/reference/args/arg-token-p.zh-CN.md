# `han.args:arg-token-p`

[English](arg-token-p.md)

*谓词*

## 语法

```text
(han.args:arg-token-p object) → generalized-boolean
```

## 说明

判断传入的 Lisp 对象是否为 `arg-token` 结构。只检查对象类型，调用后对象保持原样。

## 示例

核对词法分析得到的选项记录类型。再与无关关键字作对照。

```lisp
(let ((token
        (aref (han.args:args-input-tokens
               (han.args:parse-args-input '("demo" "--jobs=4")))
              0)))
  (list (han.args:arg-token-p token) (han.args:arg-token-p :unparsed)))
;; => (t nil)
```

从混合日志中抽取 token 的原文。

```lisp
(let ((log (list :start (han.args:make-arg-token :text "-v") :end)))
  (mapcar #'han.args:arg-token-text (remove-if-not #'han.args:arg-token-p log)))
;; => ("-v")
```

[`han.args:arg-token`](arg-token.zh-CN.md) · [`han.args:parse-args-input`](parse-args-input.zh-CN.md) · [源码](../../../args/lexer.lisp) · [索引](../README.zh-CN.md)
