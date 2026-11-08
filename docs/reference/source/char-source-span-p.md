# `han.source:char-source-span-p`

*Predicate · 谓词*

## Syntax · 语法

```text
(han.source:char-source-span-p object) → boolean
```

## Description · 说明

Tests whether an object is a span. Even two coincident marks produce a valid, empty span. To check ownership, use `source-span-from-source-p`.

判断对象是否为区间。起止标记位于同一位置时得到的空区间也是合法区间。来源归属可用 `source-span-from-source-p` 另查。

## Examples · 示例

**Distinguish an empty span from the mark used to create it · 区分空区间与创建该区间所用的标记**

```lisp
(let* ((src (han.source:make-char-source ""))
       (mark (han.source:make-source-mark src)))
  (list (han.source:char-source-span-p (han.source:make-source-span mark mark))
        (han.source:char-source-span-p mark)))
;; => (T NIL)
```

**Collect just the matched text ranges · 只取匹配区间对应的原文**

```lisp
(let* ((src (han.source:make-char-source "id=3"))
       (start (han.source:make-source-mark src)))
  (han.source:source-advance-n src 2)
  (let ((items (list start :name (han.source:make-source-span start (han.source:make-source-mark src)))))
    (mapcar (lambda (span) (han.source:source-slice-by-span src span))
            (remove-if-not #'han.source:char-source-span-p items))))
;; => ("id")
```

[`han.source:char-source-span`](char-source-span.md) · [`han.source:source-span-from-source-p`](source-span-from-source-p.md) · [Source · 源码](../../../source/char-source.lisp) · [Index · 索引](../README.md)
