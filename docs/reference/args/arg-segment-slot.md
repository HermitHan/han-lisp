# `han.args:arg-segment-slot`

*Accessor · 访问器*

## Syntax · 语法

```text
(han.args:arg-segment-slot segment) → string or nil
(setf (han.args:arg-segment-slot segment) new-value) → new-value
```

## Description · 说明

Return the slot name without its surrounding `@` and `:`. A `nil` slot contains top-level arguments, including input after a switch back with `@:`.

返回去掉首尾 `@` 和 `:` 的槽名。`nil` 表示顶层槽，其中也包含使用 `@:` 切回顶层后的参数。

## Examples · 示例

Read the name of the second segment. 读取第二段所属于的槽。

```lisp
(let ((segment
        (second (han.args:args-input-segments
                 (han.args:parse-args-input '("demo" "-v" "@filter:" "high" "low"))))))
  (han.args:arg-segment-slot segment))
;; => "filter"
```

Return to the top level after a named slot. 读取命名槽后切回顶层，查看三个段的归属。

```lisp
(let ((input
        (han.args:parse-args-input '("demo" "-v" "@files:" "a.txt" "@:" "z"))))
  (mapcar #'han.args:arg-segment-slot (han.args:args-input-segments input)))
;; => (nil "files" nil)
```

[`han.args:arg-segment`](arg-segment.md) · [`han.args:parse-args-input`](parse-args-input.md) · [Source · 源码](../../../args/lexer.lisp) · [Index · 索引](../README.md)
