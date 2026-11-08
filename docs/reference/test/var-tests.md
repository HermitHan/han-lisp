# `han.test:*tests*`

*Special variable · 特殊变量*

## Syntax · 语法

```text
han.test:*tests* → current registry
```

## Description · 说明

Holds the list of test cases registered in the current dynamic binding. `deftest` adds or replaces entries and the runners consult this registry. Bind it to `nil` with `let` to create a temporary suite. Leaving the binding restores the previous registry.

保存当前动态绑定下的测试用例列表。`deftest` 添加或替换条目，运行器从此表选取测试。在 `let` 中将它绑定为 `nil` 即可临时创建独立套件，退出后恢复原注册表。

## Examples · 示例

Count the tests in a newly bound registry.

统计新绑定的注册表中有多少用例。

```lisp
(let ((han.test:*tests* nil))
  (han.test:deftest first-sample () t)
  (han.test:deftest second-sample () t)
  (length han.test:*tests*))
;; => 2
```

Leaving a nested binding restores the outer suite and its registered test.

退出内层绑定后会恢复外层套件及其已登记的用例。

```lisp
(let ((han.test:*tests* nil))
  (han.test:deftest outer-case () :ok)
  (list (let ((han.test:*tests* nil)) (length han.test:*tests*))
        (length han.test:*tests*)))
;; => (0 1)
```

[`reset-tests`](reset-tests.md) · [`deftest`](deftest.md) · [`run-all-tests`](run-all-tests.md) · [Source · 源码](../../../test/core.lisp#L3) · [Index · 索引](../README.md)
