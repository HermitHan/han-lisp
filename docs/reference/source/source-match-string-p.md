# `han.source:source-match-string-p`

*Predicate · 谓词*

## Syntax · 语法

```text
(han.source:source-match-string-p source target) → boolean
```

## Description · 说明

Compares the remaining prefix to `target` case-sensitively, leaving the cursor unchanged. If too few characters remain it returns false. An empty target matches even at EOF.

区分大小写地比较剩余文本是否以 `target` 开头，游标保持原位。剩余长度不足时返回假。空串在输入末尾也能匹配。

## Examples · 示例

**Try two arrow spellings and peek at the first character afterward · 尝试匹配两种箭头拼法，随后查看首字符**

```lisp
(let ((src (han.source:make-char-source "->x")))
  (list (han.source:source-match-string-p src "->") (han.source:source-match-string-p src "-->")
        (han.source:source-peek-char src)))
;; => (T NIL #\-)
```

**An empty prefix at EOF is distinct from a nonempty one · 在末尾区分空前缀和非空前缀**

```lisp
(let ((src (han.source:make-char-source "")))
  (values (han.source:source-match-string-p src "") (han.source:source-match-string-p src ":")))
;; => values (T NIL)
```

[`han.source:source-consume-string-if`](source-consume-string-if.md) · [`han.source:source-peek-string`](source-peek-string.md) · [Source · 源码](../../../source/char-source.lisp) · [Index · 索引](../README.md)
