# `han.source:make-source-mark`

[English](make-source-mark.md)

*构造函数*

## 语法

```text
(han.source:make-source-mark source) → mark
```

## 说明

保存游标的当前位置和来源标识，游标仍停留在原处。以后继续读取时，标记保留捕获时的坐标，可以充当同源区间的任一端点。

## 示例

**读过一个字符后，比较保存的索引和游标的当前索引**

```lisp
(let* ((src (han.source:make-char-source "42"))
       (start (han.source:make-source-mark src)))
  (han.source:source-next-char src)
  (list (han.source:source-location start) (han.source:source-location src)))
;; => (0 1)
```

**保存换行后的位置**

```lisp
(let ((src (han.source:make-char-source (format nil "A~%BC"))))
  (han.source:source-advance-n src 2)
  (let ((line-start (han.source:make-source-mark src)))
    (han.source:source-advance-n src 2)
    (han.source:source-location line-start)))
;; => values (2 2 1)
```

[`han.source:source-location`](source-location.zh-CN.md) · [`han.source:source-reset`](source-reset.zh-CN.md) · [`han.source:make-source-span`](make-source-span.zh-CN.md) · [源码](../../../source/char-source.lisp) · [索引](../README.zh-CN.md)
