# `han.source:source-slice-by-span`

*Function · 函数*

## Syntax · 语法

```text
(han.source:source-slice-by-span source span) → string
```

## Description · 说明

Copies the substring at the span’s stored offsets. It can be recovered after the cursor has moved or been reset. A span from another origin signals an error.

按区间中保存的偏移复制子串。游标继续移动或回退之后仍可以取回这段文本。区间与游标来源不一致时会报错。

## Examples · 示例

**Save a span around two digits and recover the digits after rewinding · 保存两位数字的区间，回退游标后再取出数字**

```lisp
(let* ((src (han.source:make-char-source "42!"))
       (start (han.source:make-source-mark src)))
  (han.source:source-advance-n src 2)
  (let ((digits (han.source:make-source-span start (han.source:make-source-mark src))))
    (han.source:source-reset src start)
    (han.source:source-slice-by-span src digits)))
;; => "42"
```

**Reject a span from another cursor · 用错游标读取区间时报告错误**

```lisp
(defparameter *foreign-span*
  (let* ((original (han.source:make-char-source "A"))
         (mark (han.source:make-source-mark original)))
    (han.source:make-source-span mark mark)))
(defparameter *cursor* (han.source:make-char-source "A"))
(han.source:source-slice-by-span *cursor* *foreign-span*)
;; signals simple-error
```

[`han.source:make-source-span`](make-source-span.md) · [`han.source:source-slice`](source-slice.md) · [`han.source:source-reset`](source-reset.md) · [Source · 源码](../../../source/char-source.lisp) · [Index · 索引](../README.md)
