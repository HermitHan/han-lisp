# `han.args:parse-args-input`

[English](parse-args-input.md)

*函数*

## 语法

```text
(han.args:parse-args-input &optional (raw-input-args (han.host:argv t)) (add-cmd nil))
  → args-input
```

## 说明

解析字符串参数列表，可以先把 `add-cmd` 中的字符串加到列表前面。合并后的第一项作为命令；后续元素按零基位置生成 token，并划入顶层段或命名段。省略 `raw-input-args` 时使用[宿主 argv](../host/argv.zh-CN.md)，其中可能包含 ECL 或 CCL 的解释器选项。若只需解析 `--` 后面的应用参数，可显式传入这部分列表，并在 `add-cmd` 中指定命令名。词法警告保存在返回的输入对象中。

## 示例

给不含命令名的参数列表补入命令并解析。

```lisp
(let ((input (han.args:parse-args-input
              '("--jobs=4" "@filter:" "") '("report"))))
  (list (han.args:args-input-raw-cmd input)
        (mapcar #'han.args:arg-segment-slot (han.args:args-input-segments input))
        (han.args:arg-token-extra (aref (han.args:args-input-tokens input) 0))))
;; => ("report" (nil "filter") "4")
```

对可疑标记保留原 token，并报告位置。

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

只有命令名时仍会产生顶层段。

```lisp
(let ((input
        (han.args:parse-args-input '("demo"))))
  (values (han.args:args-input-raw-cmd input)
          (length (han.args:args-input-tokens input))
          (mapcar #'han.args:arg-segment-slot (han.args:args-input-segments input))))
;; => values ("demo" 0 (nil))
```

[`han.args:args-input`](args-input.zh-CN.md) · [`han.args:parse-args-spec`](parse-args-spec.zh-CN.md) · [源码](../../../args/lexer.lisp) · [索引](../README.zh-CN.md)
