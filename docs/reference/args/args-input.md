# `han.args:args-input`

*Structure type · 结构类型*

## Syntax · 语法

```text
han.args:args-input
(typep object 'han.args:args-input) → generalized-boolean
```

## Description · 说明

Lexical analysis of one invocation. It keeps the command separate from argv and links token indices to slot segments. This stage can report ambiguous token spellings before an argument specification exists.

一次调用的词法分析结果。命令名和 argv 分开保存，段通过索引关联 token。尚未提供参数规格时，这一步就能报告容易产生歧义的输入写法。

## Examples · 示例

Recognize the object representing a complete invocation. 确认词法分析结果是完整的输入记录。

```lisp
(let ((input (han.args:parse-args-input '("demo" "notes.txt" "@filter:" "--mode=fast"))))
  (typep input 'han.args:args-input))
;; => t
```

Let a caller pass either an argv list or an already parsed invocation. 为同一调用入口同时接收字符串列表和已解析的输入对象。

```lisp
(flet ((command-of (x)
         (etypecase x
           (han.args:args-input (han.args:args-input-raw-cmd x))
           (list (han.args:args-input-raw-cmd (han.args:parse-args-input x))))))
  (list (command-of '("list")) (command-of (han.args:parse-args-input '("show")))))
;; => ("list" "show")
```

[`han.args:args-input-p`](args-input-p.md) · [`han.args:make-args-input`](make-args-input.md) · [`han.args:parse-args-input`](parse-args-input.md) · [Source · 源码](../../../args/lexer.lisp) · [Index · 索引](../README.md)
