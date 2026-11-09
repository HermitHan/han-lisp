# `han.test:check-true`

[简体中文](check-true.zh-CN.md)

*Macro*

## Syntax

```text
(han.test:check-true form) → t
```

## Description

Evaluate `form` once and require a non-`nil` primary value. Return `t` on success. A false value signals an error identifying the form, so the runner can report the test as failed.

## Examples

Use a successful sequence search as a generalized boolean.

```lisp
(han.test:check-true (member :ready '(:queued :ready)))
;; => T
```

A failed search produces nil and makes this assertion signal an error.

```lisp
(han.test:check-true (find :ready '(:queued :done)))
;; signals simple-error
```

[`check-false`](check-false.md) · [`check-equal`](check-equal.md) · [Source](../../../test/core.lisp#L31) · [Index](../README.md)
