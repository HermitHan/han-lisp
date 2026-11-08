# `han.test:reset-tests`

*Function · 函数*

## Syntax · 语法

```text
(han.test:reset-tests) → t
```

## Description · 说明

Clear the registry in the current binding of `*tests*` and return `t`. Future runs see an empty suite until new tests are registered. In a shared REPL, a local binding limits the reset to the suite under construction.

清空 `*tests*` 当前绑定所指的注册表，并返回 `t`。在登记新测试前，运行器看到的是空套件。共享 REPL 中可以用局部绑定限定清理范围。

## Examples · 示例

Clear a populated registry and inspect the result.

清空已经有用例的注册表，并检查结果。

```lisp
(let ((han.test:*tests* nil))
  (han.test:deftest sample () t)
  (list (length han.test:*tests*)
        (han.test:reset-tests)
        (length han.test:*tests*)))
;; => (1 T 0)
```

Resetting again is harmless. A subsequent full run reports two zero counts.

再次清空也是有效操作。此时运行整个套件会得到两个零。

```lisp
(let ((han.test:*tests* nil))
  (han.test:reset-tests)
  (han.test:reset-tests)
  (han.test:run-all-tests))
;; => values (0 0)
```

[`*tests*`](var-tests.md) · [`run-all-tests`](run-all-tests.md) · [Source · 源码](../../../test/core.lisp#L9) · [Index · 索引](../README.md)
