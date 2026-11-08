# `han.source:source-skip-while`

*Function · 函数*

## Syntax · 语法

```text
(han.source:source-skip-while source predicate) → source
```

## Description · 说明

Calls the predicate on each next character and advances while the result is true. Leaves the first rejected character available and returns the cursor. At EOF the predicate is not called.

依次把下一个字符交给谓词，为真时推进。遇到第一个不满足条件的字符就停在它之前，返回原游标。到末尾时不会再调用谓词。

## Examples · 示例

**Skip leading spaces and peek at the start of the name · 跳过开头的空格并查看名称的首字符**

```lisp
(let ((src (han.source:make-char-source "   name")))
  (han.source:source-skip-while src (lambda (ch) (char= ch #\Space)))
  (han.source:source-peek-char src))
;; => #\n
```

**Skip whitespace up to EOF across a newline · 跳过空白，跨越换行直到输入末尾**

```lisp
(let ((src (han.source:make-char-source (format nil " ~% "))))
  (han.source:source-skip-while src (lambda (ch) (member ch '(#\Space #\Newline))))
  (han.source:source-location src))
;; => values (3 2 2)
```

[`han.source:source-read-while`](source-read-while.md) · [`han.source:source-peek-char`](source-peek-char.md) · [Source · 源码](../../../source/char-source.lisp) · [Index · 索引](../README.md)
