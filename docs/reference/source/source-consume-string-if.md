# `han.source:source-consume-string-if`

*Function · 函数*

## Syntax · 语法

```text
(han.source:source-consume-string-if source str) → string-or-nil
```

## Description · 说明

Consumes a matching prefix and returns the supplied string. On mismatch it returns `nil` and leaves the index unchanged. An empty string succeeds without advancing, which matters in a repeating parser.

匹配到 `str` 前缀时消耗它并返回传入的字符串；不匹配则返回 `nil` 并停在原位。空串能匹配但不会推进游标，在循环解析中要注意这一点。

## Examples · 示例

**Try two candidate prefixes and consume the matching `::` · 尝试两种前缀并消耗匹配的 `::`**

```lisp
(let ((src (han.source:make-char-source "::tag")))
  (list (han.source:source-consume-string-if src "->") (han.source:source-consume-string-if src "::")
        (han.source:source-peek-char src)))
;; => (NIL "::" #\t)
```

**An empty delimiter matches without making progress · 空分隔符匹配成功但不推进位置**

```lisp
(let ((src (han.source:make-char-source "ab")))
  (values (han.source:source-consume-string-if src "") (han.source:source-location src)))
;; => values ("" 0)
```

[`han.source:source-match-string-p`](source-match-string-p.md) · [`han.source:source-consume-char-if`](source-consume-char-if.md) · [Source · 源码](../../../source/char-source.lisp) · [Index · 索引](../README.md)
