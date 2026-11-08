# `han.source:source-next-char`

*Function · 函数*

## Syntax · 语法

```text
(han.source:source-next-char source) → character-or-nil
```

## Description · 说明

Returns and consumes the current character. At EOF it returns `nil` without advancing. A newline advances the line and resets the column to one, so diagnostic positions remain in step with consumption.

返回当前字符并把游标推进一位。到末尾时返回 `nil` 并停在原位。读到换行符会让行号加一、列号回到一，使诊断坐标与已读字符对应。

## Examples · 示例

**Read a newline, inspect the new coordinates and try one more read at end of input · 读入换行符、查看新的坐标，再在输入末尾尝试读取一次**

```lisp
(let ((src (han.source:make-char-source (string #\Newline))))
  (list (han.source:source-next-char src) (multiple-value-list (han.source:source-location src))
        (han.source:source-next-char src)))
;; => (#\Newline (1 2 1) NIL)
```

**Repeated reads at EOF preserve all coordinates · 反复读取末尾仍保持全部坐标**

```lisp
(let ((src (han.source:make-char-source "A")))
  (han.source:source-next-char src)
  (han.source:source-next-char src)
  (values (han.source:source-next-char src) (multiple-value-list (han.source:source-location src))))
;; => values (NIL (1 1 2))
```

[`han.source:source-peek-char`](source-peek-char.md) · [`han.source:source-location`](source-location.md) · [`han.source:source-advance-n`](source-advance-n.md) · [Source · 源码](../../../source/char-source.lisp) · [Index · 索引](../README.md)
