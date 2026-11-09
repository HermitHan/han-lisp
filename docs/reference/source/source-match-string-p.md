# `han.source:source-match-string-p`

[简体中文](source-match-string-p.zh-CN.md)

*Predicate*

## Syntax

```text
(han.source:source-match-string-p source target) → boolean
```

## Description

Compares the remaining prefix to `target` case-sensitively, leaving the cursor unchanged. If too few characters remain it returns false. An empty target matches even at EOF.

## Examples

**Try two arrow spellings and peek at the first character afterward**

```lisp
(let ((src (han.source:make-char-source "->x")))
  (list (han.source:source-match-string-p src "->") (han.source:source-match-string-p src "-->")
        (han.source:source-peek-char src)))
;; => (T NIL #\-)
```

**An empty prefix at EOF is distinct from a nonempty one**

```lisp
(let ((src (han.source:make-char-source "")))
  (values (han.source:source-match-string-p src "") (han.source:source-match-string-p src ":")))
;; => values (T NIL)
```

[`han.source:source-consume-string-if`](source-consume-string-if.md) · [`han.source:source-peek-string`](source-peek-string.md) · [Source](../../../source/char-source.lisp) · [Index](../README.md)
