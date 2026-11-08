# `han.args:make-arg-token`

*Constructor · 构造器*

## Syntax · 语法

```text
(han.args:make-arg-token &key kind text value extra position) → han.args:arg-token
```

## Description · 说明

Construct and return a fresh `arg-token` with the supplied keyword fields. Omitted fields default to `nil`. Its fields are normally filled together by the lexer, which assigns the position after removing the command name.

根据给定的关键字字段创建并返回新的 `arg-token` 对象。省略的字段默认为 `nil`。通常由词法分析器同时填充各字段，从命令名之后的第一项开始给各 token 编号。

## Examples · 示例

Supply both a raw spelling and an attached value. 构建同时保留原文和内联值的选项 token。

```lisp
(let ((token
        (han.args:make-arg-token
         :kind :long-option :text "--jobs=4" :value "jobs" :extra "4" :position 0)))
  (han.args:arg-token-text token))
;; => "--jobs=4"
```

Construct an ordinary value containing an equals sign. 构造含有等号的普通参数并检查附加值是否为空。

```lisp
(let ((token (han.args:make-arg-token :kind :value :text "a=b" :value "a=b")))
  (values (han.args:arg-token-value token) (han.args:arg-token-extra token)))
;; => values ("a=b" nil)
```

[`han.args:arg-token`](arg-token.md) · [`han.args:arg-token-text`](arg-token-text.md) · [`han.args:parse-args-input`](parse-args-input.md) · [Source · 源码](../../../args/lexer.lisp) · [Index · 索引](../README.md)
