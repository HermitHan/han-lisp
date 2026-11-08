# `han.source:char-source-span`

*Structure type · 结构类型*

## Syntax · 语法

```text
han.source:char-source-span
```

## Description · 说明

A half-open range of character offsets from one origin. Construct it from two marks and give it back to the originating cursor to recover the exact matched text.

半开区间类型，记录同一个字符源内的起止偏移。用两个位置标记构造区间，再交给原字符源即可取回当时匹配到的原文。

## Examples · 示例

**Consume one character and check the type of the span between the two marks · 读过一个字符，检查前后两个标记所划定的区间类型**

```lisp
(let* ((src (han.source:make-char-source "ab"))
       (start (han.source:make-source-mark src)))
  (han.source:source-next-char src)
  (typep (han.source:make-source-span start (han.source:make-source-mark src)) 'han.source:char-source-span))
;; => T
```

**Carry the token range past a rewind · 游标回退后仍可传递并读取词元的原区间**

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

[`han.source:make-source-span`](make-source-span.md) · [`han.source:source-slice-by-span`](source-slice-by-span.md) · [`han.source:char-source-span-p`](char-source-span-p.md) · [Source · 源码](../../../source/char-source.lisp) · [Index · 索引](../README.md)
