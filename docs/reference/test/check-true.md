# `han.test:check-true`

*Macro · 宏*

## Syntax · 语法

```text
(han.test:check-true form) → t
```

## Description · 说明

Evaluate `form` once and require a non-`nil` primary value. Return `t` on success. A false value signals an error identifying the form, so the runner can report the test as failed.

对 `form` 求值一次，要求其主值为非 `nil`。成功返回 `t`，得到假值时会发出带原表达式信息的错误，使运行器把用例记为失败。

## Examples · 示例

Use a successful sequence search as a generalized boolean.

将序列查找成功时得到的非空列表用作真值。

```lisp
(han.test:check-true (member :ready '(:queued :ready)))
;; => T
```

A failed search produces nil and makes this assertion signal an error.

查找失败会得到 nil，断言随即报错。

```lisp
(han.test:check-true (find :ready '(:queued :done)))
;; signals simple-error
```

[`check-false`](check-false.md) · [`check-equal`](check-equal.md) · [Source · 源码](../../../test/core.lisp#L31) · [Index · 索引](../README.md)
