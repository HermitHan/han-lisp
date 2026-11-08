# `han.source:make-char-source`

*Constructor · 构造函数*

## Syntax · 语法

```text
(han.source:make-char-source string) → source
```

## Description · 说明

Copies `string` and creates a cursor at character index 0, line 1, column 1. Every call creates a new origin, including calls with identical text. A non-string argument signals a type error.

复制输入字符串，创建一个位于索引 0、第 1 行第 1 列的游标。即使传入相同文本，每次也会产生新的来源标识。输入类型不符会触发类型错误。

## Examples · 示例

**Change the caller’s string and inspect the new cursor’s text and starting coordinates · 修改传入的字符串，再检查新游标保存的文本和起始坐标**

```lisp
(let* ((input (copy-seq "red"))
       (src (han.source:make-char-source input)))
  (setf (char input 0) #\b)
  (list (han.source:char-source-string src)
        (multiple-value-list (han.source:source-location src))))
;; => ("red" (0 1 1))
```

**Reject a list of characters as input · 字符列表不能直接用作输入字符串**

```lisp
(han.source:make-char-source (list #\a #\b))
;; signals type-error
```

[`han.source:char-source`](char-source.md) · [`han.source:char-source-string`](char-source-string.md) · [`han.source:source-same-origin-p`](source-same-origin-p.md) · [Source · 源码](../../../source/char-source.lisp) · [Index · 索引](../README.md)
