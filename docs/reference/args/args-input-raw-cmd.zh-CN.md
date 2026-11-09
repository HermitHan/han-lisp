# `han.args:args-input-raw-cmd`

[English](args-input-raw-cmd.md)

*访问器*

## 语法

```text
(han.args:args-input-raw-cmd input) → string or nil
(setf (han.args:args-input-raw-cmd input) new-value) → new-value
```

## 说明

返回合并后的输入列表的第一项，即命令名。空输入返回 `nil`。

## 示例

从带参数的调用中取出命令名。

```lisp
(let ((input (han.args:parse-args-input '("demo" "notes.txt" "@filter:" "--mode=fast"))))
  (han.args:args-input-raw-cmd input))
;; => "demo"
```

外层只提供选项时，可以单独补入命令名。

```lisp
(han.args:args-input-raw-cmd
 (han.args:parse-args-input '("-v") '("inspect")))
;; => "inspect"
```

[`han.args:args-input`](args-input.zh-CN.md) · [`han.args:parse-args-input`](parse-args-input.zh-CN.md) · [源码](../../../args/lexer.lisp) · [索引](../README.zh-CN.md)
