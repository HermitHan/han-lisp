# `han.source:source-match-char-p`

[简体中文](source-match-char-p.zh-CN.md)

*Predicate*

## Syntax

```text
(han.source:source-match-char-p source ch) → boolean
```

## Description

Checks whether the next character equals `ch` using `char=`. The cursor stays at its original index on either outcome. An exhausted source returns false.

## Examples

**Compare letter case and inspect the cursor’s offset after both checks**

```lisp
(let ((src (han.source:make-char-source "A")))
  (list (han.source:source-match-char-p src #\a) (han.source:source-match-char-p src #\A)
        (han.source:source-location src)))
;; => (NIL T 0)
```

**EOF has no character to match**

```lisp
(let ((src (han.source:make-char-source ".")))
  (han.source:source-next-char src)
  (values (han.source:source-eof-p src) (han.source:source-match-char-p src #\.)))
;; => values (T NIL)
```

[`han.source:source-consume-char-if`](source-consume-char-if.md) · [`han.source:source-match-string-p`](source-match-string-p.md) · [Source](../../../source/char-source.lisp) · [Index](../README.md)
