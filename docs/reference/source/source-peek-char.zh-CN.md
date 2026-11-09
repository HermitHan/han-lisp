# `han.source:source-peek-char`

[English](source-peek-char.md)

*函数*

## 语法

```text
(han.source:source-peek-char source) → character-or-nil
```

## 说明

查看当前位置的字符而保持游标不动。末尾返回 `nil`。解析器可以先查看同一字符，再决定由哪个分支消耗它。

## 示例

**连续两次查看同一个等号，再核对游标索引**

```lisp
(let ((src (han.source:make-char-source "=8")))
  (list (han.source:source-peek-char src) (han.source:source-peek-char src) (han.source:source-location src)))
;; => (#\= #\= 0)
```

**查看空输入的首字符**

```lisp
(let ((src (han.source:make-char-source "")))
  (values (han.source:source-peek-char src) (han.source:source-eof-p src)))
;; => values (NIL T)
```

[`han.source:source-next-char`](source-next-char.zh-CN.md) · [`han.source:source-peek-string`](source-peek-string.zh-CN.md) · [源码](../../../source/char-source.lisp) · [索引](../README.zh-CN.md)
