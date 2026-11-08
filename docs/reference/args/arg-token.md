# `han.args:arg-token`

*Structure type · 结构类型*

## Syntax · 语法

```text
han.args:arg-token
(typep object 'han.args:arg-token) → generalized-boolean
```

## Description · 说明

A parsed argv element with its original spelling, normalized value, and position. Named slot switches are tokens too.

解析后的单个 argv 元素，保存原文、规范化值和位置。用于切换命名槽的标记也会形成 token。

## Examples · 示例

Check the type of an option record returned by the lexer. 核对词法分析得到的选项记录类型。

```lisp
(let ((token
        (aref (han.args:args-input-tokens
               (han.args:parse-args-input '("demo" "--jobs=4")))
              0)))
  (typep token 'han.args:arg-token))
;; => t
```

Inspect a token and preserve plain text from a mixed forwarding queue. 处理混合转发队列中的 token 和普通字符串。

```lisp
(let ((queue (list (han.args:make-arg-token :text "--help") "raw")))
  (mapcar (lambda (item)
            (etypecase item
              (han.args:arg-token (han.args:arg-token-text item))
              (string item)))
          queue))
;; => ("--help" "raw")
```

[`han.args:arg-token-p`](arg-token-p.md) · [`han.args:make-arg-token`](make-arg-token.md) · [`han.args:parse-args-input`](parse-args-input.md) · [Source · 源码](../../../args/lexer.lisp) · [Index · 索引](../README.md)
