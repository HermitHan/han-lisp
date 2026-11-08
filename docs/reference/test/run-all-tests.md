# `han.test:run-all-tests`

*Function · 函数*

## Syntax · 语法

```text
(han.test:run-all-tests) → passed-count, failed-count
```

## Description · 说明

Run registered cases in registration order, print their results and a summary to standard output, then return two integer counts. Each case that reports failure still allows later cases to run. An empty suite returns two zeros. A script can use the counts to choose its exit status.

按注册顺序运行全部用例，向标准输出打印每项结果和汇总，再返回通过数与失败数两个整数。一个用例报告失败后继续运行后面的用例。空套件返回两个零。脚本可用这两个计数决定退出码。

## Examples · 示例

Read both counts from a suite containing two passing cases.

读取包含两个通过用例的套件所返回的计数。

```lisp
(let ((han.test:*tests* nil))
  (han.test:deftest accepts-zero () (han.test:check-true (zerop 0)))
  (han.test:deftest accepts-one () (han.test:check-true (plusp 1)))
  (multiple-value-list (han.test:run-all-tests)))
;; => (2 0)
```

A failed case still allows a later case to run. The two return values count the outcomes separately.

一个用例失败后，随后登记的用例依旧会执行。两个返回值分别统计结果。

```lisp
(let ((han.test:*tests* nil)
      (*standard-output* (make-broadcast-stream)))
  (han.test:deftest outdated-baseline () (han.test:check-equal 5 (+ 2 2)))
  (han.test:deftest current-baseline () (han.test:check-equal 4 (+ 2 2)))
  (han.test:run-all-tests))
;; => values (1 1)
```

A newly isolated suite with no tests has neither passes nor failures.

新绑定的空套件既无通过项，也无失败项。

```lisp
(let ((han.test:*tests* nil))
  (han.test:run-all-tests))
;; => values (0 0)
```

[`run-test`](run-test.md) · [`*tests*`](var-tests.md) · [Source · 源码](../../../test/core.lisp#L71) · [Index · 索引](../README.md)
