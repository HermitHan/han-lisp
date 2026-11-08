# `han.args:args-input-raw-argv`

*Accessor · 访问器*

## Syntax · 语法

```text
(han.args:args-input-raw-argv input) → list of strings
(setf (han.args:args-input-raw-argv input) new-value) → new-value
```

## Description · 说明

Return the argument strings following the command name, with their original spelling, order, and argument boundaries intact.

返回命令名之后的参数字符串，保留原始写法、顺序以及元素之间的分界。

## Examples · 示例

Retrieve the arguments following a command. 取回命令名之后的输入列表。

```lisp
(let ((input (han.args:parse-args-input '("demo" "notes.txt" "@filter:" "--mode=fast"))))
  (han.args:args-input-raw-argv input))
;; => ("notes.txt" "@filter:" "--mode=fast")
```

Preserve argument boundaries from the calling process. 已经切分的参数可以含有空格，也可以是空串。

```lisp
(han.args:args-input-raw-argv
 (han.args:parse-args-input '("inspect" "a b" "" "--")))
;; => ("a b" "" "--")
```

[`han.args:args-input`](args-input.md) · [`han.args:parse-args-input`](parse-args-input.md) · [Source · 源码](../../../args/lexer.lisp) · [Index · 索引](../README.md)
