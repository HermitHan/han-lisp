# `han.source:char-source-p`

[English](char-source-p.md)

*谓词*

## 语法

```text
(han.source:char-source-p object) → boolean
```

## 说明

判断对象是不是字符源游标。保存的位置属于另一种类型，两者都可以交给 `source-location` 查询。

## 示例

**分别传入游标和标记，判断哪个是字符源**

```lisp
(let ((src (han.source:make-char-source "a")))
  (list (han.source:char-source-p src)
        (han.source:char-source-p (han.source:make-source-mark src))))
;; => (T NIL)
```

**复用调用方已经推进的游标**

```lisp
(let ((cursor (han.source:make-char-source "v2")))
  (han.source:source-next-char cursor)
  (flet ((as-source (x) (if (han.source:char-source-p x) x (han.source:make-char-source x))))
    (mapcar (lambda (x) (han.source:source-peek-char (as-source x)))
            (list cursor "v2"))))
;; => (#\2 #\v)
```

[`han.source:char-source`](char-source.zh-CN.md) · [`han.source:char-source-mark-p`](char-source-mark-p.zh-CN.md) · [源码](../../../source/char-source.lisp) · [索引](../README.zh-CN.md)
