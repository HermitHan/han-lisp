# `han.args:args-input-raw-argv`

[English](args-input-raw-argv.md)

*访问器*

## 语法

```text
(han.args:args-input-raw-argv input) → list of strings
(setf (han.args:args-input-raw-argv input) new-value) → new-value
```

## 说明

返回命令名之后的参数字符串，保留原始写法、顺序以及元素之间的分界。

## 示例

取回命令名之后的输入列表。

```lisp
(let ((input (han.args:parse-args-input '("demo" "notes.txt" "@filter:" "--mode=fast"))))
  (han.args:args-input-raw-argv input))
;; => ("notes.txt" "@filter:" "--mode=fast")
```

已经切分的参数可以含有空格，也可以是空串。

```lisp
(han.args:args-input-raw-argv
 (han.args:parse-args-input '("inspect" "a b" "" "--")))
;; => ("a b" "" "--")
```

[`han.args:args-input`](args-input.zh-CN.md) · [`han.args:parse-args-input`](parse-args-input.zh-CN.md) · [源码](../../../args/lexer.lisp) · [索引](../README.zh-CN.md)
