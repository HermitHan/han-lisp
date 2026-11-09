# `han.source:source-next-char`

[English](source-next-char.md)

*函数*

## 语法

```text
(han.source:source-next-char source) → character-or-nil
```

## 说明

返回当前字符并把游标推进一位。到末尾时返回 `nil` 并停在原位。读到换行符会让行号加一、列号回到一，使诊断坐标与已读字符对应。

## 示例

**读入换行符、查看新的坐标，再在输入末尾尝试读取一次**

```lisp
(let ((src (han.source:make-char-source (string #\Newline))))
  (list (han.source:source-next-char src) (multiple-value-list (han.source:source-location src))
        (han.source:source-next-char src)))
;; => (#\Newline (1 2 1) NIL)
```

**反复读取末尾仍保持全部坐标**

```lisp
(let ((src (han.source:make-char-source "A")))
  (han.source:source-next-char src)
  (han.source:source-next-char src)
  (values (han.source:source-next-char src) (multiple-value-list (han.source:source-location src))))
;; => values (NIL (1 1 2))
```

[`han.source:source-peek-char`](source-peek-char.zh-CN.md) · [`han.source:source-location`](source-location.zh-CN.md) · [`han.source:source-advance-n`](source-advance-n.zh-CN.md) · [源码](../../../source/char-source.lisp) · [索引](../README.zh-CN.md)
