# `han.source:char-source-mark`

*Structure type · 结构类型*

## Syntax · 语法

```text
han.source:char-source-mark
```

## Description · 说明

A saved position containing an origin and the cursor’s index, line and column at the time of capture. Use it to return to a parsing decision or to bound a slice. Create it with `make-source-mark`.

保存读取位置的结构类型，记录捕获时的来源、索引、行和列。可以用标记回到一次解析决策前的位置，也可用它指定子串边界。

## Examples · 示例

**Check the type of a mark saved at the start of the input · 检查在输入起点保存的标记类型**

```lisp
(let ((src (han.source:make-char-source "42")))
  (typep (han.source:make-source-mark src) 'han.source:char-source-mark))
;; => T
```

**Read coordinates from either a cursor or a saved mark · 同一位置查询可以接受标记或当前游标**

```lisp
(let* ((src (han.source:make-char-source "a:"))
       (before (han.source:make-source-mark src)))
  (han.source:source-next-char src)
  (mapcar (lambda (x)
            (etypecase x
              (han.source:char-source-mark (list :saved (han.source:source-location x)))
              (han.source:char-source (list :current (han.source:source-location x)))))
          (list before src)))
;; => ((:SAVED 0) (:CURRENT 1))
```

[`han.source:make-source-mark`](make-source-mark.md) · [`han.source:source-reset`](source-reset.md) · [`han.source:source-slice`](source-slice.md) · [Source · 源码](../../../source/char-source.lisp) · [Index · 索引](../README.md)
