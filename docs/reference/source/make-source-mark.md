# `han.source:make-source-mark`

*Constructor · 构造函数*

## Syntax · 语法

```text
(han.source:make-source-mark source) → mark
```

## Description · 说明

Captures the current position and source identity without advancing. The saved coordinates survive later reads and can serve as either end of a same-source span.

保存游标的当前位置和来源标识，游标仍停留在原处。以后继续读取时，标记保留捕获时的坐标，可以充当同源区间的任一端点。

## Examples · 示例

**Compare the saved offset with the cursor after reading one character · 读过一个字符后，比较保存的索引和游标的当前索引**

```lisp
(let* ((src (han.source:make-char-source "42"))
       (start (han.source:make-source-mark src)))
  (han.source:source-next-char src)
  (list (han.source:source-location start) (han.source:source-location src)))
;; => (0 1)
```

**Save a position immediately after a newline · 保存换行后的位置**

```lisp
(let ((src (han.source:make-char-source (format nil "A~%BC"))))
  (han.source:source-advance-n src 2)
  (let ((line-start (han.source:make-source-mark src)))
    (han.source:source-advance-n src 2)
    (han.source:source-location line-start)))
;; => values (2 2 1)
```

[`han.source:source-location`](source-location.md) · [`han.source:source-reset`](source-reset.md) · [`han.source:make-source-span`](make-source-span.md) · [Source · 源码](../../../source/char-source.lisp) · [Index · 索引](../README.md)
