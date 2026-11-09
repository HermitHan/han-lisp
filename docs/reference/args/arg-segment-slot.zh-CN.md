# `han.args:arg-segment-slot`

[English](arg-segment-slot.md)

*访问器*

## 语法

```text
(han.args:arg-segment-slot segment) → string or nil
(setf (han.args:arg-segment-slot segment) new-value) → new-value
```

## 说明

返回去掉首尾 `@` 和 `:` 的槽名。`nil` 表示顶层槽，其中也包含使用 `@:` 切回顶层后的参数。

## 示例

读取第二段所属于的槽。

```lisp
(let ((segment
        (second (han.args:args-input-segments
                 (han.args:parse-args-input '("demo" "-v" "@filter:" "high" "low"))))))
  (han.args:arg-segment-slot segment))
;; => "filter"
```

读取命名槽后切回顶层，查看三个段的归属。

```lisp
(let ((input
        (han.args:parse-args-input '("demo" "-v" "@files:" "a.txt" "@:" "z"))))
  (mapcar #'han.args:arg-segment-slot (han.args:args-input-segments input)))
;; => (nil "files" nil)
```

[`han.args:arg-segment`](arg-segment.zh-CN.md) · [`han.args:parse-args-input`](parse-args-input.zh-CN.md) · [源码](../../../args/lexer.lisp) · [索引](../README.zh-CN.md)
