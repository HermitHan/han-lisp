# `han.source:char-source-length`

*Accessor · 访问器*

## Syntax · 语法

```text
(han.source:char-source-length source) → character-count
(setf (han.source:char-source-length source) new-value) → new-value
```

## Description · 说明

Returns the length recorded when the source was created, in Lisp characters. Advancing or rewinding the cursor leaves the total unchanged. Treat this slot and the stored input as a pair. The generated writer changes only this slot. To replace the input and initialize its coordinates, create a fresh source.

返回创建字符源时记录的总长度，以 Lisp 字符计数。推进或回退游标后总长度保持不变。该槽与存储的文本应保持一致。 结构体生成的写入器只更新这一个槽。需要更换输入文本并初始化坐标时，应创建新的字符源。

## Examples · 示例

**Check the total length of `汉A` and the cursor’s offset after reading one character · 读过首字符后，核对 `汉A` 的总字符数和当前索引**

```lisp
(let ((src (han.source:make-char-source "汉A")))
  (han.source:source-next-char src)
  (list (han.source:char-source-length src) (han.source:source-location src)))
;; => (2 1)
```

**Count the remaining characters after a partial read · 读取一部分后计算剩余字符数**

```lisp
(let ((src (han.source:make-char-source (format nil "甲~%BC"))))
  (han.source:source-advance-n src 2)
  (- (han.source:char-source-length src) (han.source:source-location src)))
;; => 2
```

[`han.source:char-source-string`](char-source-string.md) · [`han.source:source-location`](source-location.md) · [`han.source:source-eof-p`](source-eof-p.md) · [Source · 源码](../../../source/char-source.lisp) · [Index · 索引](../README.md)
