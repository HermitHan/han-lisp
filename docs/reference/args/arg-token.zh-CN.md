# `han.args:arg-token`

[English](arg-token.md)

*结构类型*

## 语法

```text
han.args:arg-token
(typep object 'han.args:arg-token) → generalized-boolean
```

## 说明

解析后的单个 argv 元素，保存原文、规范化值和位置。用于切换命名槽的标记也会形成 token。

## 示例

核对词法分析得到的选项记录类型。

```lisp
(let ((token
        (aref (han.args:args-input-tokens
               (han.args:parse-args-input '("demo" "--jobs=4")))
              0)))
  (typep token 'han.args:arg-token))
;; => t
```

处理混合转发队列中的 token 和普通字符串。

```lisp
(let ((queue (list (han.args:make-arg-token :text "--help") "raw")))
  (mapcar (lambda (item)
            (etypecase item
              (han.args:arg-token (han.args:arg-token-text item))
              (string item)))
          queue))
;; => ("--help" "raw")
```

[`han.args:arg-token-p`](arg-token-p.zh-CN.md) · [`han.args:make-arg-token`](make-arg-token.zh-CN.md) · [`han.args:parse-args-input`](parse-args-input.zh-CN.md) · [源码](../../../args/lexer.lisp) · [索引](../README.zh-CN.md)
