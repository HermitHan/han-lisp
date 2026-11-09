# `han.args:make-arg-token`

[English](make-arg-token.md)

*构造器*

## 语法

```text
(han.args:make-arg-token &key kind text value extra position) → han.args:arg-token
```

## 说明

根据给定的关键字字段创建并返回新的 `arg-token` 对象。省略的字段默认为 `nil`。通常由词法分析器同时填充各字段，从命令名之后的第一项开始给各 token 编号。

## 示例

构建同时保留原文和内联值的选项 token。

```lisp
(let ((token
        (han.args:make-arg-token
         :kind :long-option :text "--jobs=4" :value "jobs" :extra "4" :position 0)))
  (han.args:arg-token-text token))
;; => "--jobs=4"
```

构造含有等号的普通参数并检查附加值是否为空。

```lisp
(let ((token (han.args:make-arg-token :kind :value :text "a=b" :value "a=b")))
  (values (han.args:arg-token-value token) (han.args:arg-token-extra token)))
;; => values ("a=b" nil)
```

[`han.args:arg-token`](arg-token.zh-CN.md) · [`han.args:arg-token-text`](arg-token-text.zh-CN.md) · [`han.args:parse-args-input`](parse-args-input.zh-CN.md) · [源码](../../../args/lexer.lisp) · [索引](../README.zh-CN.md)
