# `han.args:parse-args-input`

*Function · 函数*

## Syntax · 语法

```text
(han.args:parse-args-input &optional (raw-input-args (han.host:argv t)) (add-cmd nil))
  → args-input
```

## Description · 说明

Lex a list of argument strings, optionally prepending the strings in `add-cmd`. The first combined item is the command. Each subsequent item receives a zero-based token position and belongs to a top-level or named segment. Omitting `raw-input-args` reads the process arguments. Lexical warnings are stored on the returned input.

解析字符串参数列表，可以先把 `add-cmd` 中的字符串加到列表前面。合并后的第一项作为命令；后续元素按零基位置生成 token，并划入顶层段或命名段。省略 `raw-input-args` 时读取当前进程的参数。词法警告保存在返回的输入对象中。

## Examples · 示例

Tokenize options supplied separately from the executable name. 给不含命令名的参数列表补入命令并解析。

```lisp
(let ((input (han.args:parse-args-input
              '("--jobs=4" "@filter:" "") '("report"))))
  (list (han.args:args-input-raw-cmd input)
        (mapcar #'han.args:arg-segment-slot (han.args:args-input-segments input))
        (han.args:arg-token-extra (aref (han.args:args-input-tokens input) 0))))
;; => ("report" (nil "filter") "4")
```

Retain a suspicious marker and its warning. 对可疑标记保留原 token，并报告位置。

```lisp
(let ((input
        (han.args:parse-args-input '("demo" "--"))))
  (let ((token (aref (han.args:args-input-tokens input) 0))
        (warning (first (han.args:args-input-diagnostics input))))
    (values (han.args:arg-token-kind token)
            (han.args:arg-token-text token)
            (han.args:arg-diagnostic-position warning))))
;; => values (:value "--" 0)
```

Inspect a call containing only a command name. 只有命令名时仍会产生顶层段。

```lisp
(let ((input
        (han.args:parse-args-input '("demo"))))
  (values (han.args:args-input-raw-cmd input)
          (length (han.args:args-input-tokens input))
          (mapcar #'han.args:arg-segment-slot (han.args:args-input-segments input))))
;; => values ("demo" 0 (nil))
```

[`han.args:args-input`](args-input.md) · [`han.args:parse-args-spec`](parse-args-spec.md) · [Source · 源码](../../../args/lexer.lisp) · [Index · 索引](../README.md)
