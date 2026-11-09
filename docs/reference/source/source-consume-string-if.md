# `han.source:source-consume-string-if`

[简体中文](source-consume-string-if.zh-CN.md)

*Function*

## Syntax

```text
(han.source:source-consume-string-if source str) → string-or-nil
```

## Description

Consumes a matching prefix and returns the supplied string. On mismatch it returns `nil` and leaves the index unchanged. An empty string succeeds without advancing, which matters in a repeating parser.

## Examples

**Try two candidate prefixes and consume the matching `::`**

```lisp
(let ((src (han.source:make-char-source "::tag")))
  (list (han.source:source-consume-string-if src "->") (han.source:source-consume-string-if src "::")
        (han.source:source-peek-char src)))
;; => (NIL "::" #\t)
```

**An empty delimiter matches without making progress**

```lisp
(let ((src (han.source:make-char-source "ab")))
  (values (han.source:source-consume-string-if src "") (han.source:source-location src)))
;; => values ("" 0)
```

[`han.source:source-match-string-p`](source-match-string-p.md) · [`han.source:source-consume-char-if`](source-consume-char-if.md) · [Source](../../../source/char-source.lisp) · [Index](../README.md)
