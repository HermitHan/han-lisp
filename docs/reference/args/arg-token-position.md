# `han.args:arg-token-position`

*Accessor · 访问器*

## Syntax · 语法

```text
(han.args:arg-token-position token) → nonnegative integer
(setf (han.args:arg-token-position token) new-value) → new-value
```

## Description · 说明

Return the zero-based index in the arguments following the command name. The same index addresses the token in `args-input-tokens`.

返回 token 在命令名之后的参数列表中的索引，从零起算。用同一索引可以访问 `args-input-tokens` 中的 token。

## Examples · 示例

Find the first argument after the command. 读取命令名之后首个参数的位置。

```lisp
(let ((token
        (aref (han.args:args-input-tokens
               (han.args:parse-args-input '("demo" "--jobs=4")))
              0)))
  (han.args:arg-token-position token))
;; => 0
```

Locate an argument after a slot switch. 槽切换符也占一个位置，可用索引定位切回顶层后的参数。

```lisp
(let ((input
        (han.args:parse-args-input '("demo" "@files:" "a.txt" "@:" "-v"))))
  (map 'list #'han.args:arg-token-position (han.args:args-input-tokens input)))
;; => (0 1 2 3)
```

[`han.args:arg-token`](arg-token.md) · [`han.args:parse-args-input`](parse-args-input.md) · [Source · 源码](../../../args/lexer.lisp) · [Index · 索引](../README.md)
