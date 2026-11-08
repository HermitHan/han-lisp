# `han.source:char-source-p`

*Predicate · 谓词*

## Syntax · 语法

```text
(han.source:char-source-p object) → boolean
```

## Description · 说明

Recognizes character-source structures. A saved position is a separate type even though it can also be passed to `source-location`.

判断对象是不是字符源游标。保存的位置属于另一种类型，两者都可以交给 `source-location` 查询。

## Examples · 示例

**Recognize the cursor when given either a cursor or a mark · 分别传入游标和标记，判断哪个是字符源**

```lisp
(let ((src (han.source:make-char-source "a")))
  (list (han.source:char-source-p src)
        (han.source:char-source-p (han.source:make-source-mark src))))
;; => (T NIL)
```

**Reuse a caller’s cursor at its current position · 复用调用方已经推进的游标**

```lisp
(let ((cursor (han.source:make-char-source "v2")))
  (han.source:source-next-char cursor)
  (flet ((as-source (x) (if (han.source:char-source-p x) x (han.source:make-char-source x))))
    (mapcar (lambda (x) (han.source:source-peek-char (as-source x)))
            (list cursor "v2"))))
;; => (#\2 #\v)
```

[`han.source:char-source`](char-source.md) · [`han.source:char-source-mark-p`](char-source-mark-p.md) · [Source · 源码](../../../source/char-source.lisp) · [Index · 索引](../README.md)
