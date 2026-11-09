# `han.source:source-read-while`

[English](source-read-while.md)

*函数*

## 语法

```text
(han.source:source-read-while source predicate) → string
```

## 说明

消耗连续满足谓词的字符，并返回对应字符串。第一个失配字符留在输入中。若首字符即失配或已在末尾，则返回空串。

## 示例

**读取组成端口号的连续数字，为下一步保留斜杠**

```lisp
(let ((src (han.source:make-char-source "8080/tcp")))
  (list (han.source:source-read-while src #'digit-char-p) (han.source:source-peek-char src)))
;; => ("8080" #\/)
```

**首字符失配后留给下一个分支处理**

```lisp
(let ((src (han.source:make-char-source "-12")))
  (values (han.source:source-read-while src #'digit-char-p)
          (han.source:source-consume-char-if src #\-)
          (han.source:source-read-while src #'digit-char-p)))
;; => values ("" #\- "12")
```

[`han.source:source-skip-while`](source-skip-while.zh-CN.md) · [`han.source:source-peek-char`](source-peek-char.zh-CN.md) · [`han.source:source-slice`](source-slice.zh-CN.md) · [源码](../../../source/char-source.lisp) · [索引](../README.zh-CN.md)
