# `han.source:source-location`

[English](source-location.md)

*函数*

## 语法

```text
(han.source:source-location source-or-mark) → index, line, column
```

## 说明

接受游标或标记，分别返回索引、行、列三个整数。索引从零开始计算已消耗的字符；行列从一开始。读过换行符后行数加一，列数回到一。传入区间会报错。

## 示例

**读过换行符后查看索引、行和列**

```lisp
(let ((src (han.source:make-char-source (format nil "ab~%cd"))))
  (han.source:source-advance-n src 3)
  (multiple-value-list (han.source:source-location src)))
;; => (3 2 1)
```

**读完一行之后查询旧标记的位置**

```lisp
(let ((src (han.source:make-char-source "key=1")))
  (han.source:source-advance-n src 3)
  (let ((separator (han.source:make-source-mark src)))
    (han.source:source-advance-n src 2)
    (han.source:source-location separator)))
;; => values (3 1 4)
```

**区间有两个端点，不能当作单个位置**

```lisp
(defparameter *span*
  (let* ((src (han.source:make-char-source ""))
         (mark (han.source:make-source-mark src)))
    (han.source:make-source-span mark mark)))
(han.source:source-location *span*)
;; signals simple-error
```

[`han.source:make-source-mark`](make-source-mark.zh-CN.md) · [`han.source:source-next-char`](source-next-char.zh-CN.md) · [`han.source:source-reset`](source-reset.zh-CN.md) · [源码](../../../source/char-source.lisp) · [索引](../README.zh-CN.md)
