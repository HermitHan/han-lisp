# `han.test:*tests*`

[简体中文](var-tests.zh-CN.md)

*Special variable*

## Syntax

```text
han.test:*tests* → current registry
```

## Description

Holds the list of test cases registered in the current dynamic binding. `deftest` adds or replaces entries and the runners consult this registry. Bind it to `nil` with `let` to create a temporary suite. Leaving the binding restores the previous registry.

## Examples

Count the tests in a newly bound registry.

```lisp
(let ((han.test:*tests* nil))
  (han.test:deftest first-sample () t)
  (han.test:deftest second-sample () t)
  (length han.test:*tests*))
;; => 2
```

Leaving a nested binding restores the outer suite and its registered test.

```lisp
(let ((han.test:*tests* nil))
  (han.test:deftest outer-case () :ok)
  (list (let ((han.test:*tests* nil)) (length han.test:*tests*))
        (length han.test:*tests*)))
;; => (0 1)
```

[`reset-tests`](reset-tests.md) · [`deftest`](deftest.md) · [`run-all-tests`](run-all-tests.md) · [Source](../../../test/core.lisp#L3) · [Index](../README.md)
