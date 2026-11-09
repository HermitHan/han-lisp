# `han.source:source-eof-p`

[English](source-eof-p.md)

*谓词*

## 语法

```text
(han.source:source-eof-p source) → boolean
```

## 说明

检查游标的索引是否已到达文本长度。空文本创建后即在末尾。在末尾查看字符不会改变状态。

## 示例

**分别在读取唯一字符前后检查是否到达末尾**

```lisp
(let ((src (han.source:make-char-source "x")))
  (list (han.source:source-eof-p src) (han.source:source-next-char src) (han.source:source-eof-p src)))
;; => (NIL #\x T)
```

**空字段从一开始就在末尾**

```lisp
(let ((src (han.source:make-char-source "")))
  (values (han.source:source-eof-p src) (han.source:source-peek-string src 4)))
;; => values (T "")
```

[`han.source:source-peek-char`](source-peek-char.zh-CN.md) · [`han.source:source-next-char`](source-next-char.zh-CN.md) · [源码](../../../source/char-source.lisp) · [索引](../README.zh-CN.md)
