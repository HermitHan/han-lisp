# `han.args:args-input-raw-cmd`

*Accessor · 访问器*

## Syntax · 语法

```text
(han.args:args-input-raw-cmd input) → string or nil
(setf (han.args:args-input-raw-cmd input) new-value) → new-value
```

## Description · 说明

Return the first string of the combined input list. This is the command name. Empty input yields `nil`.

返回合并后的输入列表的第一项，即命令名。空输入返回 `nil`。

## Examples · 示例

Separate the executable name from the argument list. 从带参数的调用中取出命令名。

```lisp
(let ((input (han.args:parse-args-input '("demo" "notes.txt" "@filter:" "--mode=fast"))))
  (han.args:args-input-raw-cmd input))
;; => "demo"
```

Supply the command name separately when argv contains only options. 外层只提供选项时，可以单独补入命令名。

```lisp
(han.args:args-input-raw-cmd
 (han.args:parse-args-input '("-v") '("inspect")))
;; => "inspect"
```

[`han.args:args-input`](args-input.md) · [`han.args:parse-args-input`](parse-args-input.md) · [Source · 源码](../../../args/lexer.lisp) · [Index · 索引](../README.md)
