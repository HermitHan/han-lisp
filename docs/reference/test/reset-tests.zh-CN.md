# `han.test:reset-tests`

[English](reset-tests.md)

*函数*

## 语法

```text
(han.test:reset-tests) → t
```

## 说明

清空 `*tests*` 当前绑定所指的注册表，并返回 `t`。在登记新测试前，运行器看到的是空套件。共享 REPL 中可以用局部绑定限定清理范围。

## 示例

清空已经有用例的注册表，并检查结果。

```lisp
(let ((han.test:*tests* nil))
  (han.test:deftest sample () t)
  (list (length han.test:*tests*)
        (han.test:reset-tests)
        (length han.test:*tests*)))
;; => (1 T 0)
```

再次清空也是有效操作。此时运行整个套件会得到两个零。

```lisp
(let ((han.test:*tests* nil))
  (han.test:reset-tests)
  (han.test:reset-tests)
  (han.test:run-all-tests))
;; => values (0 0)
```

[`*tests*`](var-tests.zh-CN.md) · [`run-all-tests`](run-all-tests.zh-CN.md) · [源码](../../../test/core.lisp#L9) · [索引](../README.zh-CN.md)
