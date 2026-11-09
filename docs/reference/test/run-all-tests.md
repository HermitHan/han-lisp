# `han.test:run-all-tests`

[简体中文](run-all-tests.zh-CN.md)

*Function*

## Syntax

```text
(han.test:run-all-tests) → passed-count, failed-count
```

## Description

Run registered cases in registration order, print their results and a summary to standard output, then return two integer counts. Each case that reports failure still allows later cases to run. An empty suite returns two zeros. A script can use the counts to choose its exit status.

## Examples

Read both counts from a suite containing two passing cases.

```lisp
(let ((han.test:*tests* nil))
  (han.test:deftest accepts-zero () (han.test:check-true (zerop 0)))
  (han.test:deftest accepts-one () (han.test:check-true (plusp 1)))
  (multiple-value-list (han.test:run-all-tests)))
;; => (2 0)
```

A failed case still allows a later case to run. The two return values count the outcomes separately.

```lisp
(let ((han.test:*tests* nil)
      (*standard-output* (make-broadcast-stream)))
  (han.test:deftest outdated-baseline () (han.test:check-equal 5 (+ 2 2)))
  (han.test:deftest current-baseline () (han.test:check-equal 4 (+ 2 2)))
  (han.test:run-all-tests))
;; => values (1 1)
```

A newly isolated suite with no tests has neither passes nor failures.

```lisp
(let ((han.test:*tests* nil))
  (han.test:run-all-tests))
;; => values (0 0)
```

[`run-test`](run-test.md) · [`*tests*`](var-tests.md) · [Source](../../../test/core.lisp#L69) · [Index](../README.md)
