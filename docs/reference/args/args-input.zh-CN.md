# `han.args:args-input`

[English](args-input.md)

*结构类型*

## 语法

```text
han.args:args-input
(typep object 'han.args:args-input) → generalized-boolean
```

## 说明

一次调用的词法分析结果。命令名和 argv 分开保存，段通过索引关联 token。尚未提供参数规格时，这一步就能报告容易产生歧义的输入写法。

## 示例

确认词法分析结果是完整的输入记录。

```lisp
(let ((input (han.args:parse-args-input '("demo" "notes.txt" "@filter:" "--mode=fast"))))
  (typep input 'han.args:args-input))
;; => t
```

为同一调用入口同时接收字符串列表和已解析的输入对象。

```lisp
(flet ((command-of (x)
         (etypecase x
           (han.args:args-input (han.args:args-input-raw-cmd x))
           (list (han.args:args-input-raw-cmd (han.args:parse-args-input x))))))
  (list (command-of '("list")) (command-of (han.args:parse-args-input '("show")))))
;; => ("list" "show")
```

[`han.args:args-input-p`](args-input-p.zh-CN.md) · [`han.args:make-args-input`](make-args-input.zh-CN.md) · [`han.args:parse-args-input`](parse-args-input.zh-CN.md) · [源码](../../../args/lexer.lisp) · [索引](../README.zh-CN.md)
