# `han.source:source-eof-p`

*Predicate · 谓词*

## Syntax · 语法

```text
(han.source:source-eof-p source) → boolean
```

## Description · 说明

Tests whether the cursor index has reached the recorded input length. An empty input is at EOF immediately. Peeking at EOF leaves the result unchanged.

检查游标的索引是否已到达文本长度。空文本创建后即在末尾。在末尾查看字符不会改变状态。

## Examples · 示例

**Check for end of input before and after reading the only character · 分别在读取唯一字符前后检查是否到达末尾**

```lisp
(let ((src (han.source:make-char-source "x")))
  (list (han.source:source-eof-p src) (han.source:source-next-char src) (han.source:source-eof-p src)))
;; => (NIL #\x T)
```

**An empty field starts at EOF · 空字段从一开始就在末尾**

```lisp
(let ((src (han.source:make-char-source "")))
  (values (han.source:source-eof-p src) (han.source:source-peek-string src 4)))
;; => values (T "")
```

[`han.source:source-peek-char`](source-peek-char.md) · [`han.source:source-next-char`](source-next-char.md) · [Source · 源码](../../../source/char-source.lisp) · [Index · 索引](../README.md)
