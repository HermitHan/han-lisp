# `han.source:make-char-source`

[English](make-char-source.md)

*构造函数*

## 语法

```text
(han.source:make-char-source string) → source
```

## 说明

复制输入字符串，创建一个位于索引 0、第 1 行第 1 列的游标。即使传入相同文本，每次也会产生新的来源标识。输入类型不符会触发类型错误。

## 示例

**修改传入的字符串，再检查新游标保存的文本和起始坐标**

```lisp
(let* ((input (copy-seq "red"))
       (src (han.source:make-char-source input)))
  (setf (char input 0) #\b)
  (list (han.source:char-source-string src)
        (multiple-value-list (han.source:source-location src))))
;; => ("red" (0 1 1))
```

**字符列表不能直接用作输入字符串**

```lisp
(han.source:make-char-source (list #\a #\b))
;; signals type-error
```

[`han.source:char-source`](char-source.zh-CN.md) · [`han.source:char-source-string`](char-source-string.zh-CN.md) · [`han.source:source-same-origin-p`](source-same-origin-p.zh-CN.md) · [源码](../../../source/char-source.lisp) · [索引](../README.zh-CN.md)
