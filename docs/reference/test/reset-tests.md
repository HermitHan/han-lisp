# `han.test:reset-tests`

[简体中文](reset-tests.zh-CN.md)

*Function*

## Syntax

```text
(han.test:reset-tests) → t
```

## Description

Clear the registry in the current binding of `*tests*` and return `t`. Future runs see an empty suite until new tests are registered. In a shared REPL, a local binding limits the reset to the suite under construction.

## Examples

Clear a populated registry and inspect the result.

```lisp
(let ((han.test:*tests* nil))
  (han.test:deftest sample () t)
  (list (length han.test:*tests*)
        (han.test:reset-tests)
        (length han.test:*tests*)))
;; => (1 T 0)
```

Resetting again is harmless. A subsequent full run reports two zero counts.

```lisp
(let ((han.test:*tests* nil))
  (han.test:reset-tests)
  (han.test:reset-tests)
  (han.test:run-all-tests))
;; => values (0 0)
```

[`*tests*`](var-tests.md) · [`run-all-tests`](run-all-tests.md) · [Source](../../../test/core.lisp#L9) · [Index](../README.md)
