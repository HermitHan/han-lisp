# `han.source:source-match-char-p`

[English](source-match-char-p.md)

*谓词*

## 语法

```text
(han.source:source-match-char-p source ch) → boolean
```

## 说明

用 `char=` 判断下一个字符是否等于 `ch`。无论是否匹配都保持游标位置；输入用尽时返回假。

## 示例

**分别匹配大小写字母，并查看两次匹配后的游标索引**

```lisp
(let ((src (han.source:make-char-source "A")))
  (list (han.source:source-match-char-p src #\a) (han.source:source-match-char-p src #\A)
        (han.source:source-location src)))
;; => (NIL T 0)
```

**输入用尽后无法匹配字符**

```lisp
(let ((src (han.source:make-char-source ".")))
  (han.source:source-next-char src)
  (values (han.source:source-eof-p src) (han.source:source-match-char-p src #\.)))
;; => values (T NIL)
```

[`han.source:source-consume-char-if`](source-consume-char-if.zh-CN.md) · [`han.source:source-match-string-p`](source-match-string-p.zh-CN.md) · [源码](../../../source/char-source.lisp) · [索引](../README.zh-CN.md)
