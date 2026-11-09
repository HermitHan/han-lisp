# `han.test:check-equal`

[简体中文](check-equal.zh-CN.md)

*Macro*

## Syntax

```text
(han.test:check-equal expected form) → t
```

## Description

Evaluate `expected` and `form` once each and compare their primary values using `equal`. Return `t` on success or signal an error containing both values on mismatch. Use `multiple-value-list` to compare several return values or `check-true` with `equalp` to compare general vectors element by element.

## Examples

Collect a quotient and remainder before comparing them together.

```lisp
(han.test:check-equal '(2 1) (multiple-value-list (floor 7 3)))
;; => T
```

A case difference in two strings is significant to equal.

```lisp
(han.test:check-equal "read" "READ")
;; signals simple-error
```

The actual expression runs once, even when it changes state.

```lisp
(let ((count 0))
  (list (han.test:check-equal 1 (incf count)) count))
;; => (T 1)
```

[`check-true`](check-true.md) · [`check-false`](check-false.md) · [Source](../../../test/core.lisp#L43) · [Index](../README.md)
