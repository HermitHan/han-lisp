# `han.source:source-consume-char-if`

[简体中文](source-consume-char-if.zh-CN.md)

*Function*

## Syntax

```text
(han.source:source-consume-char-if source ch) → character-or-nil
```

## Description

If the next character matches `ch`, advances by one and returns `ch`. A mismatch or EOF returns `nil` and leaves the input available to another parsing branch.

## Examples

**Try a colon, then consume the equals sign and peek at the digit**

```lisp
(let ((src (han.source:make-char-source "=5")))
  (list (han.source:source-consume-char-if src #\:) (han.source:source-consume-char-if src #\=)
        (han.source:source-peek-char src)))
;; => (NIL #\= #\5)
```

**A missing delimiter at EOF leaves the end position intact**

```lisp
(let ((src (han.source:make-char-source "")))
  (values (han.source:source-consume-char-if src #\,) (han.source:source-location src)))
;; => values (NIL 0)
```

[`han.source:source-match-char-p`](source-match-char-p.md) · [`han.source:source-consume-string-if`](source-consume-string-if.md) · [Source](../../../source/char-source.lisp) · [Index](../README.md)
