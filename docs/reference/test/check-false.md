# `han.test:check-false`

[简体中文](check-false.zh-CN.md)

*Macro*

## Syntax

```text
(han.test:check-false form) → t
```

## Description

Evaluate `form` once. A `nil` primary value passes and returns `t`. A non-`nil` result signals an error that includes the unexpected value and the expression. In Lisp, zero and the empty string are both true.

## Examples

Check that the failure marker is absent from a status list.

```lisp
(han.test:check-false (find :failed '(:queued :done)))
;; => T
```

Common Lisp treats zero as true, including when it is the index of a match.

```lisp
(han.test:check-false (position :first '(:first :second)))
;; signals simple-error
```

[`check-true`](check-true.md) · [`check-equal`](check-equal.md) · [Source](../../../test/core.lisp#L37) · [Index](../README.md)
