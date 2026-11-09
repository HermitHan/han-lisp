# `han.source:make-source-span`

[English](make-source-span.md)

*构造函数*

## 语法

```text
(han.source:make-source-span start-mark end-mark) → span
```

## 说明

创建从起始标记到结束标记之前的区间。两端必须同源，且结束位置不能早于起始位置，否则报错。两位置相等时得到空区间。

## 示例

**在 `id=7` 的名称两端做标记并取出名称**

```lisp
(let* ((src (han.source:make-char-source "id=7"))
       (start (han.source:make-source-mark src)))
  (han.source:source-read-while src #'alpha-char-p)
  (han.source:source-slice-by-span src (han.source:make-source-span start (han.source:make-source-mark src))))
;; => "id"
```

**用零长度区间表示两个分隔符之间的空字段**

```lisp
(let* ((src (han.source:make-char-source "::"))
       (field-start (progn (han.source:source-next-char src) (han.source:make-source-mark src))))
  (han.source:source-slice-by-span src (han.source:make-source-span field-start field-start)))
;; => ""
```

**拒绝前后顺序颠倒的两个端点**

```lisp
(defparameter *cursor* (han.source:make-char-source "id"))
(defparameter *begin* (han.source:make-source-mark *cursor*))
(han.source:source-next-char *cursor*)
(defparameter *end* (han.source:make-source-mark *cursor*))
(han.source:make-source-span *end* *begin*)
;; signals simple-error
```

[`han.source:make-source-mark`](make-source-mark.zh-CN.md) · [`han.source:source-slice-by-span`](source-slice-by-span.zh-CN.md) · [`han.source:source-span-from-source-p`](source-span-from-source-p.zh-CN.md) · [源码](../../../source/char-source.lisp) · [索引](../README.zh-CN.md)
