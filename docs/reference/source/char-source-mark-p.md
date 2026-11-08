# `han.source:char-source-mark-p`

*Predicate · 谓词*

## Syntax · 语法

```text
(han.source:char-source-mark-p object) → boolean
```

## Description · 说明

Tests whether `object` is a saved mark. To use it on a particular cursor, check the additional origin constraint with `source-mark-from-source-p`.

判断对象是否为位置标记。要在某个游标上使用它，还可以用 `source-mark-from-source-p` 检查来源。

## Examples · 示例

**Distinguish a saved mark from its running cursor · 区分保存的位置标记和当前游标**

```lisp
(let ((src (han.source:make-char-source "42")))
  (list (han.source:char-source-mark-p (han.source:make-source-mark src))
        (han.source:char-source-mark-p src)))
;; => (T NIL)
```

**Find the saved position among mixed parser data · 从混合解析数据中取出位置标记**

```lisp
(let ((src (han.source:make-char-source "=42")))
  (han.source:source-next-char src)
  (let ((items (list :equals (han.source:make-source-mark src) src)))
    (han.source:source-location (find-if #'han.source:char-source-mark-p items))))
;; => values (1 1 2)
```

[`han.source:char-source-mark`](char-source-mark.md) · [`han.source:source-mark-from-source-p`](source-mark-from-source-p.md) · [Source · 源码](../../../source/char-source.lisp) · [Index · 索引](../README.md)
