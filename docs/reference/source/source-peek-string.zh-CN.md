# `han.source:source-peek-string`

[English](source-peek-string.md)

*函数*

## 语法

```text
(han.source:source-peek-string source n) → string
```

## 说明

从当前位置查看至多 `n` 个字符，`n` 为非负整数。剩余输入较短就取到末尾，在末尾得到空串。游标保持不动。

## 示例

**在只剩两个冒号时向前查看五个字符**

```lisp
(let ((src (han.source:make-char-source "x::")))
  (han.source:source-next-char src)
  (list (han.source:source-peek-string src 5) (han.source:source-location src)))
;; => ("::" 1)
```

**在读取输入前请求零长度预览**

```lisp
(let ((src (han.source:make-char-source "word")))
  (values (han.source:source-peek-string src 0) (han.source:source-next-char src)))
;; => values ("" #\w)
```

[`han.source:source-peek-char`](source-peek-char.zh-CN.md) · [`han.source:source-match-string-p`](source-match-string-p.zh-CN.md) · [源码](../../../source/char-source.lisp) · [索引](../README.zh-CN.md)
