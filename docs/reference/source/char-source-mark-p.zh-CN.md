# `han.source:char-source-mark-p`

[English](char-source-mark-p.md)

*谓词*

## 语法

```text
(han.source:char-source-mark-p object) → boolean
```

## 说明

判断对象是否为位置标记。要在某个游标上使用它，还可以用 `source-mark-from-source-p` 检查来源。

## 示例

**区分保存的位置标记和当前游标**

```lisp
(let ((src (han.source:make-char-source "42")))
  (list (han.source:char-source-mark-p (han.source:make-source-mark src))
        (han.source:char-source-mark-p src)))
;; => (T NIL)
```

**从混合解析数据中取出位置标记**

```lisp
(let ((src (han.source:make-char-source "=42")))
  (han.source:source-next-char src)
  (let ((items (list :equals (han.source:make-source-mark src) src)))
    (han.source:source-location (find-if #'han.source:char-source-mark-p items))))
;; => values (1 1 2)
```

[`han.source:char-source-mark`](char-source-mark.zh-CN.md) · [`han.source:source-mark-from-source-p`](source-mark-from-source-p.zh-CN.md) · [源码](../../../source/char-source.lisp) · [索引](../README.zh-CN.md)
