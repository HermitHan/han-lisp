# `han.test:check-false`

[English](check-false.md)

*宏*

## 语法

```text
(han.test:check-false form) → t
```

## 说明

对 `form` 求值一次，主值为 `nil` 时通过并返回 `t`。主值为非 `nil` 时发出错误，包含实际值和原表达式。Lisp 中的零和空字符串都是真值。

## 示例

检查状态列表里是否没有失败标记。

```lisp
(han.test:check-false (find :failed '(:queued :done)))
;; => T
```

匹配位置为零时，Common Lisp 仍将这个值视为真。

```lisp
(han.test:check-false (position :first '(:first :second)))
;; signals simple-error
```

[`check-true`](check-true.zh-CN.md) · [`check-equal`](check-equal.zh-CN.md) · [源码](../../../test/core.lisp#L37) · [索引](../README.zh-CN.md)
