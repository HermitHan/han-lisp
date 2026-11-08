# `han.test:check-false`

*Macro · 宏*

## Syntax · 语法

```text
(han.test:check-false form) → t
```

## Description · 说明

Evaluate `form` once. A `nil` primary value passes and returns `t`. A non-`nil` result signals an error that includes the unexpected value and the expression. In Lisp, zero and the empty string are both true.

对 `form` 求值一次，主值为 `nil` 时通过并返回 `t`。主值为非 `nil` 时发出错误，包含实际值和原表达式。Lisp 中的零和空字符串都是真值。

## Examples · 示例

Check that the failure marker is absent from a status list.

检查状态列表里是否没有失败标记。

```lisp
(han.test:check-false (find :failed '(:queued :done)))
;; => T
```

Common Lisp treats zero as true, including when it is the index of a match.

匹配位置为零时，Common Lisp 仍将这个值视为真。

```lisp
(han.test:check-false (position :first '(:first :second)))
;; signals simple-error
```

[`check-true`](check-true.md) · [`check-equal`](check-equal.md) · [Source · 源码](../../../test/core.lisp#L37) · [Index · 索引](../README.md)
