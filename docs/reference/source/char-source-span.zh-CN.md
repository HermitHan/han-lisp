# `han.source:char-source-span`

[English](char-source-span.md)

*结构类型*

## 语法

```text
han.source:char-source-span
```

## 说明

半开区间类型，记录同一个字符源内的起止偏移。用两个位置标记构造区间，再交给原字符源即可取回当时匹配到的原文。

## 示例

**读过一个字符，检查前后两个标记所划定的区间类型**

```lisp
(let* ((src (han.source:make-char-source "ab"))
       (start (han.source:make-source-mark src)))
  (han.source:source-next-char src)
  (typep (han.source:make-source-span start (han.source:make-source-mark src)) 'han.source:char-source-span))
;; => T
```

**游标回退后仍可传递并读取词元的原区间**

```lisp
(let* ((src (han.source:make-char-source "42:"))
       (begin (han.source:make-source-mark src)))
  (han.source:source-read-while src #'digit-char-p)
  (let ((token (han.source:make-source-span begin (han.source:make-source-mark src))))
    (han.source:source-reset src begin)
    (etypecase token
      (han.source:char-source-span (han.source:source-slice-by-span src token)))))
;; => "42"
```

[`han.source:make-source-span`](make-source-span.zh-CN.md) · [`han.source:source-slice-by-span`](source-slice-by-span.zh-CN.md) · [`han.source:char-source-span-p`](char-source-span-p.zh-CN.md) · [源码](../../../source/char-source.lisp) · [索引](../README.zh-CN.md)
