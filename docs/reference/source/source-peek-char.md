# `han.source:source-peek-char`

*Function · 函数*

## Syntax · 语法

```text
(han.source:source-peek-char source) → character-or-nil
```

## Description · 说明

Reads the character at the current index without advancing. Returns `nil` at EOF. Repeated peeks let a parser decide which branch should consume the character.

查看当前位置的字符而保持游标不动。末尾返回 `nil`。解析器可以先查看同一字符，再决定由哪个分支消耗它。

## Examples · 示例

**Peek at the same equals sign twice and check the offset · 连续两次查看同一个等号，再核对游标索引**

```lisp
(let ((src (han.source:make-char-source "=8")))
  (list (han.source:source-peek-char src) (han.source:source-peek-char src) (han.source:source-location src)))
;; => (#\= #\= 0)
```

**Peeking at an empty source returns immediately · 查看空输入的首字符**

```lisp
(let ((src (han.source:make-char-source "")))
  (values (han.source:source-peek-char src) (han.source:source-eof-p src)))
;; => values (NIL T)
```

[`han.source:source-next-char`](source-next-char.md) · [`han.source:source-peek-string`](source-peek-string.md) · [Source · 源码](../../../source/char-source.lisp) · [Index · 索引](../README.md)
