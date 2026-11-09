# `han.args:args-input-segments`

[English](args-input-segments.md)

*访问器*

## 语法

```text
(han.args:args-input-segments input) → list of arg-segment
(setf (han.args:args-input-segments input) new-value) → new-value
```

## 说明

返回按输入顺序排列的段列表。解析器先建立默认段，每次切换槽再打开一个段。段内可以没有 token。

## 示例

查看顶层参数与槽参数间的分界。

```lisp
(let ((input (han.args:parse-args-input '("demo" "notes.txt" "@filter:" "--mode=fast"))))
  (mapcar #'han.args:arg-segment-slot (han.args:args-input-segments input)))
;; => (nil "filter")
```

查看各段对应的位置，以便回到原输入。

```lisp
(let ((input
        (han.args:parse-args-input '("demo" "z" "@stage:" "x" "y"))))
  (mapcar #'han.args:arg-segment-positions (han.args:args-input-segments input)))
;; => ((0) (2 3))
```

[`han.args:args-input`](args-input.zh-CN.md) · [`han.args:parse-args-input`](parse-args-input.zh-CN.md) · [源码](../../../args/lexer.lisp) · [索引](../README.zh-CN.md)
