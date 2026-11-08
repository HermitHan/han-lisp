# `han.source:char-source-string`

*Accessor · 访问器*

## Syntax · 语法

```text
(han.source:char-source-string source) → string
(setf (han.source:char-source-string source) new-value) → new-value
```

## Description · 说明

Returns the cursor’s stored string, including the text before its current position. Reading this slot does not copy it. Treat it as read-only after construction so that saved positions still identify the same text. The generated writer changes only this slot. To replace the input and initialize its coordinates, create a fresh source.

返回游标持有的整段字符串，包括已经读过的部分。读取此槽不会复制字符串。创建游标后宜按只读方式使用，以便旧标记仍对应原来的文本。 结构体生成的写入器只更新这一个槽。需要更换输入文本并初始化坐标时，应创建新的字符源。

## Examples · 示例

**Recover the full input after passing the colon · 越过冒号后仍能取回完整输入**

```lisp
(let ((src (han.source:make-char-source "alpha:beta")))
  (han.source:source-advance-n src 6)
  (han.source:char-source-string src))
;; => "alpha:beta"
```

**Two cursors constructed from one input own distinct copies · 由同一输入创建的两个游标分别持有副本**

```lisp
(let* ((input (copy-seq "AC"))
       (a (han.source:make-char-source input))
       (b (han.source:make-char-source input)))
  (list (string= (han.source:char-source-string a) (han.source:char-source-string b))
        (eq (han.source:char-source-string a) (han.source:char-source-string b))))
;; => (T NIL)
```

[`han.source:make-char-source`](make-char-source.md) · [`han.source:source-slice`](source-slice.md) · [`han.source:char-source-length`](char-source-length.md) · [Source · 源码](../../../source/char-source.lisp) · [Index · 索引](../README.md)
