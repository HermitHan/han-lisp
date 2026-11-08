# `han.source:source-peek-string`

*Function · 函数*

## Syntax · 语法

```text
(han.source:source-peek-string source n) → string
```

## Description · 说明

Returns up to `n` characters starting at the cursor. Use a nonnegative integer. If the remaining input is shorter, the result ends at EOF. At EOF the result is an empty string. The cursor does not move.

从当前位置查看至多 `n` 个字符，`n` 为非负整数。剩余输入较短就取到末尾，在末尾得到空串。游标保持不动。

## Examples · 示例

**Request five characters when only two colons remain · 在只剩两个冒号时向前查看五个字符**

```lisp
(let ((src (han.source:make-char-source "x::")))
  (han.source:source-next-char src)
  (list (han.source:source-peek-string src 5) (han.source:source-location src)))
;; => ("::" 1)
```

**Ask for a zero-length preview before consuming input · 在读取输入前请求零长度预览**

```lisp
(let ((src (han.source:make-char-source "word")))
  (values (han.source:source-peek-string src 0) (han.source:source-next-char src)))
;; => values ("" #\w)
```

[`han.source:source-peek-char`](source-peek-char.md) · [`han.source:source-match-string-p`](source-match-string-p.md) · [Source · 源码](../../../source/char-source.lisp) · [Index · 索引](../README.md)
