# `han.test:check-equal`

[English](check-equal.md)

*宏*

## 语法

```text
(han.test:check-equal expected form) → t
```

## 说明

将 `expected` 和 `form` 各求值一次，使用 `equal` 比较两个主值。成功时返回 `t`，不匹配则发出包含两个值的错误。多个返回值可先用 `multiple-value-list` 收集。逐元素比较一般向量时，可将 `equalp` 配合 `check-true` 使用。

## 示例

先收集商和余数，再作为整体比较。

```lisp
(han.test:check-equal '(2 1) (multiple-value-list (floor 7 3)))
;; => T
```

用 equal 比较字符串时，大小写差异会导致断言失败。

```lisp
(han.test:check-equal "read" "READ")
;; signals simple-error
```

即便实际值表达式会改变状态，也只会求值一次。

```lisp
(let ((count 0))
  (list (han.test:check-equal 1 (incf count)) count))
;; => (T 1)
```

[`check-true`](check-true.zh-CN.md) · [`check-false`](check-false.zh-CN.md) · [源码](../../../test/core.lisp#L43) · [索引](../README.zh-CN.md)
