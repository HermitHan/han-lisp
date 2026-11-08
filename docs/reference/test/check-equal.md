# `han.test:check-equal`

*Macro · 宏*

## Syntax · 语法

```text
(han.test:check-equal expected form) → t
```

## Description · 说明

Evaluate `expected` and `form` once each and compare their primary values using `equal`. Return `t` on success or signal an error containing both values on mismatch. Use `multiple-value-list` to compare several return values or `check-true` with `equalp` to compare general vectors element by element.

将 `expected` 和 `form` 各求值一次，使用 `equal` 比较两个主值。成功时返回 `t`，不匹配则发出包含两个值的错误。多个返回值可先用 `multiple-value-list` 收集。逐元素比较一般向量时，可将 `equalp` 配合 `check-true` 使用。

## Examples · 示例

Collect a quotient and remainder before comparing them together.

先收集商和余数，再作为整体比较。

```lisp
(han.test:check-equal '(2 1) (multiple-value-list (floor 7 3)))
;; => T
```

A case difference in two strings is significant to equal.

用 equal 比较字符串时，大小写差异会导致断言失败。

```lisp
(han.test:check-equal "read" "READ")
;; signals simple-error
```

The actual expression runs once, even when it changes state.

即便实际值表达式会改变状态，也只会求值一次。

```lisp
(let ((count 0))
  (list (han.test:check-equal 1 (incf count)) count))
;; => (T 1)
```

[`check-true`](check-true.md) · [`check-false`](check-false.md) · [Source · 源码](../../../test/core.lisp#L43) · [Index · 索引](../README.md)
