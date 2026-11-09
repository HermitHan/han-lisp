# `han.test:run-all-tests`

[English](run-all-tests.md)

*函数*

## 语法

```text
(han.test:run-all-tests) → passed-count, failed-count
```

## 说明

按注册顺序运行全部用例，向标准输出打印每项结果和汇总，再返回通过数与失败数两个整数。一个用例报告失败后继续运行后面的用例。空套件返回两个零。脚本可用这两个计数决定退出码。

## 示例

读取包含两个通过用例的套件所返回的计数。

```lisp
(let ((han.test:*tests* nil))
  (han.test:deftest accepts-zero () (han.test:check-true (zerop 0)))
  (han.test:deftest accepts-one () (han.test:check-true (plusp 1)))
  (multiple-value-list (han.test:run-all-tests)))
;; => (2 0)
```

一个用例失败后，随后登记的用例依旧会执行。两个返回值分别统计结果。

```lisp
(let ((han.test:*tests* nil)
      (*standard-output* (make-broadcast-stream)))
  (han.test:deftest outdated-baseline () (han.test:check-equal 5 (+ 2 2)))
  (han.test:deftest current-baseline () (han.test:check-equal 4 (+ 2 2)))
  (han.test:run-all-tests))
;; => values (1 1)
```

新绑定的空套件既无通过项，也无失败项。

```lisp
(let ((han.test:*tests* nil))
  (han.test:run-all-tests))
;; => values (0 0)
```

[`run-test`](run-test.zh-CN.md) · [`*tests*`](var-tests.zh-CN.md) · [源码](../../../test/core.lisp#L69) · [索引](../README.zh-CN.md)
