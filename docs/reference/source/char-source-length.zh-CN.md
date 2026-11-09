# `han.source:char-source-length`

[English](char-source-length.md)

*访问器*

## 语法

```text
(han.source:char-source-length source) → character-count
(setf (han.source:char-source-length source) new-value) → new-value
```

## 说明

返回创建字符源时记录的总长度，以 Lisp 字符计数。推进或回退游标后总长度保持不变。该槽与存储的文本应保持一致。 结构体生成的写入器只更新这一个槽。需要更换输入文本并初始化坐标时，应创建新的字符源。

## 示例

**读过首字符后，核对 `汉A` 的总字符数和当前索引**

```lisp
(let ((src (han.source:make-char-source "汉A")))
  (han.source:source-next-char src)
  (list (han.source:char-source-length src) (han.source:source-location src)))
;; => (2 1)
```

**读取一部分后计算剩余字符数**

```lisp
(let ((src (han.source:make-char-source (format nil "甲~%BC"))))
  (han.source:source-advance-n src 2)
  (- (han.source:char-source-length src) (han.source:source-location src)))
;; => 2
```

[`han.source:char-source-string`](char-source-string.zh-CN.md) · [`han.source:source-location`](source-location.zh-CN.md) · [`han.source:source-eof-p`](source-eof-p.zh-CN.md) · [源码](../../../source/char-source.lisp) · [索引](../README.zh-CN.md)
