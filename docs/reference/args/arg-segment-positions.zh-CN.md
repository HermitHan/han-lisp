# `han.args:arg-segment-positions`

[English](arg-segment-positions.md)

*访问器*

## 语法

```text
(han.args:arg-segment-positions segment) → list
(setf (han.args:arg-segment-positions segment) new-value) → new-value
```

## 说明

返回该段所含 token 的索引列表，保持输入顺序。每个索引都针对完整的 token 向量，切换槽的标记在向量内也占一个位置。空段对应空列表。

## 示例

定位分到命名段的两个 token。

```lisp
(let ((segment
        (second (han.args:args-input-segments
                 (han.args:parse-args-input '("demo" "-v" "@filter:" "high" "low"))))))
  (han.args:arg-segment-positions segment))
;; => (2 3)
```

相邻槽切换符之间没有参数，仍会留下空段。

```lisp
(let ((input
        (han.args:parse-args-input '("demo" "@a:" "@b:" "z"))))
  (mapcar #'han.args:arg-segment-positions (han.args:args-input-segments input)))
;; => (nil nil (2))
```

[`han.args:arg-segment`](arg-segment.zh-CN.md) · [`han.args:parse-args-input`](parse-args-input.zh-CN.md) · [源码](../../../args/lexer.lisp) · [索引](../README.zh-CN.md)
