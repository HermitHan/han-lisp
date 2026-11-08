# `han.source:make-source-span`

*Constructor · 构造函数*

## Syntax · 语法

```text
(han.source:make-source-span start-mark end-mark) → span
```

## Description · 说明

Constructs the range from the first mark up to, and excluding, the second. The marks must have the same origin and nondecreasing offsets. Either violation signals an error. Equal offsets produce an empty range.

创建从起始标记到结束标记之前的区间。两端必须同源，且结束位置不能早于起始位置，否则报错。两位置相等时得到空区间。

## Examples · 示例

**Mark both ends of the name in `id=7` and extract it · 在 `id=7` 的名称两端做标记并取出名称**

```lisp
(let* ((src (han.source:make-char-source "id=7"))
       (start (han.source:make-source-mark src)))
  (han.source:source-read-while src #'alpha-char-p)
  (han.source:source-slice-by-span src (han.source:make-source-span start (han.source:make-source-mark src))))
;; => "id"
```

**Represent an empty field between delimiters · 用零长度区间表示两个分隔符之间的空字段**

```lisp
(let* ((src (han.source:make-char-source "::"))
       (field-start (progn (han.source:source-next-char src) (han.source:make-source-mark src))))
  (han.source:source-slice-by-span src (han.source:make-source-span field-start field-start)))
;; => ""
```

**Reject endpoints supplied in reverse order · 拒绝前后顺序颠倒的两个端点**

```lisp
(defparameter *cursor* (han.source:make-char-source "id"))
(defparameter *begin* (han.source:make-source-mark *cursor*))
(han.source:source-next-char *cursor*)
(defparameter *end* (han.source:make-source-mark *cursor*))
(han.source:make-source-span *end* *begin*)
;; signals simple-error
```

[`han.source:make-source-mark`](make-source-mark.md) · [`han.source:source-slice-by-span`](source-slice-by-span.md) · [`han.source:source-span-from-source-p`](source-span-from-source-p.md) · [Source · 源码](../../../source/char-source.lisp) · [Index · 索引](../README.md)
