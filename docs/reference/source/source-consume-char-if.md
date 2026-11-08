# `han.source:source-consume-char-if`

*Function · 函数*

## Syntax · 语法

```text
(han.source:source-consume-char-if source ch) → character-or-nil
```

## Description · 说明

If the next character matches `ch`, advances by one and returns `ch`. A mismatch or EOF returns `nil` and leaves the input available to another parsing branch.

下一个字符与 `ch` 匹配时推进一位并返回 `ch`；失配或到达末尾时返回 `nil`，后续分支仍可从原位继续。

## Examples · 示例

**Try a colon, then consume the equals sign and peek at the digit · 先尝试匹配冒号，再消耗等号并查看后面的数字**

```lisp
(let ((src (han.source:make-char-source "=5")))
  (list (han.source:source-consume-char-if src #\:) (han.source:source-consume-char-if src #\=)
        (han.source:source-peek-char src)))
;; => (NIL #\= #\5)
```

**A missing delimiter at EOF leaves the end position intact · 末尾没有分隔符时保留结束位置**

```lisp
(let ((src (han.source:make-char-source "")))
  (values (han.source:source-consume-char-if src #\,) (han.source:source-location src)))
;; => values (NIL 0)
```

[`han.source:source-match-char-p`](source-match-char-p.md) · [`han.source:source-consume-string-if`](source-consume-string-if.md) · [Source · 源码](../../../source/char-source.lisp) · [Index · 索引](../README.md)
