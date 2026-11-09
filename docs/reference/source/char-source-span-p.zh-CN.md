# `han.source:char-source-span-p`

[English](char-source-span-p.md)

*谓词*

## 语法

```text
(han.source:char-source-span-p object) → boolean
```

## 说明

判断对象是否为区间。起止标记位于同一位置时得到的空区间也是合法区间。来源归属可用 `source-span-from-source-p` 另查。

## 示例

**区分空区间与创建该区间所用的标记**

```lisp
(let* ((src (han.source:make-char-source ""))
       (mark (han.source:make-source-mark src)))
  (list (han.source:char-source-span-p (han.source:make-source-span mark mark))
        (han.source:char-source-span-p mark)))
;; => (T NIL)
```

**只取匹配区间对应的原文**

```lisp
(let* ((src (han.source:make-char-source "id=3"))
       (start (han.source:make-source-mark src)))
  (han.source:source-advance-n src 2)
  (let ((items (list start :name (han.source:make-source-span start (han.source:make-source-mark src)))))
    (mapcar (lambda (span) (han.source:source-slice-by-span src span))
            (remove-if-not #'han.source:char-source-span-p items))))
;; => ("id")
```

[`han.source:char-source-span`](char-source-span.zh-CN.md) · [`han.source:source-span-from-source-p`](source-span-from-source-p.zh-CN.md) · [源码](../../../source/char-source.lisp) · [索引](../README.zh-CN.md)
