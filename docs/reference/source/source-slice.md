# `han.source:source-slice`

*Function · 函数*

## Syntax · 语法

```text
(han.source:source-slice source start &optional end) → string
```

## Description · 说明

Copies the half-open substring between two nonnegative indices or same-source marks. The default end is the current cursor index. Bounds must fit the stored string. This operation leaves the cursor in place.

复制半开区间内的子串。起止位置可用非负整数或同源标记表示。结束位置默认取游标当前索引；边界须落在存储的字符串内。取子串不会移动游标。

## Examples · 示例

**Extract the key up to the cursor and peek at the equals sign · 取出截至游标处的键名并查看接下来的等号**

```lisp
(let ((src (han.source:make-char-source "key=17")))
  (han.source:source-advance-n src 3)
  (list (han.source:source-slice src 0) (han.source:source-peek-char src)))
;; => ("key" #\=)
```

**Slice using a saved starting mark and an explicit end offset · 用保存的起始标记与显式结束偏移取子串**

```lisp
(let ((src (han.source:make-char-source "id:42;")))
  (han.source:source-advance-n src 3)
  (let ((start (han.source:make-source-mark src)))
    (values (han.source:source-slice src start 5) (han.source:source-location src))))
;; => values ("42" 3)
```

**Reject a boundary from a different parse · 拒绝另一轮解析留下的边界**

```lisp
(defparameter *cursor* (han.source:make-char-source "xy"))
(defparameter *foreign-mark*
  (han.source:make-source-mark (han.source:make-char-source "xy")))
(han.source:source-slice *cursor* *foreign-mark* 1)
;; signals simple-error
```

[`han.source:source-slice-by-span`](source-slice-by-span.md) · [`han.source:make-source-mark`](make-source-mark.md) · [`han.source:source-location`](source-location.md) · [Source · 源码](../../../source/char-source.lisp) · [Index · 索引](../README.md)
