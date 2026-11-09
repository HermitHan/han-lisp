# `han.test:check-true`

[English](check-true.md)

*宏*

## 语法

```text
(han.test:check-true form) → t
```

## 说明

对 `form` 求值一次，要求其主值为非 `nil`。成功返回 `t`，得到假值时会发出带原表达式信息的错误，使运行器把用例记为失败。

## 示例

将序列查找成功时得到的非空列表用作真值。

```lisp
(han.test:check-true (member :ready '(:queued :ready)))
;; => T
```

查找失败会得到 nil，断言随即报错。

```lisp
(han.test:check-true (find :ready '(:queued :done)))
;; signals simple-error
```

[`check-false`](check-false.zh-CN.md) · [`check-equal`](check-equal.zh-CN.md) · [源码](../../../test/core.lisp#L31) · [索引](../README.zh-CN.md)
