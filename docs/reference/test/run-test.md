# `han.test:run-test`

*Function · 函数*

## Syntax · 语法

```text
(han.test:run-test name) → passed-p
```

## Description · 说明

Find a registered test by symbol identity and run it with zero arguments. Normal return prints a pass line and returns `t`, even if the body returned `nil`. An error raised within the test prints a failure line and returns `nil`. An unregistered name signals an error before the test handler is entered.

按符号身份查找已注册用例，以零参数运行。测试体正常返回时打印通过信息、返回 `t`，即使测试体返回的是 `nil`。执行中出现错误时打印失败信息、返回 `nil`。若名称没有登记，查找阶段会直接发出错误。

## Examples · 示例

Run a named case that checks the first element of an empty list.

按名称运行一个用例，检查空列表的首元素。

```lisp
(let ((han.test:*tests* nil))
  (han.test:deftest empty-input () (han.test:check-false (first '())))
  (han.test:run-test 'empty-input))
;; => T
```

A failing assertion returns a false test result to the runner’s caller.

断言失败时，运行器向调用方返回假值。

```lisp
(let ((han.test:*tests* nil)
      (*standard-output* (make-broadcast-stream)))
  (han.test:deftest short-record () (han.test:check-equal 2 (length '(a))))
  (han.test:run-test 'short-record))
;; => NIL
```

An unknown test name signals an error before the runner can invoke a test body.

测试名未登记时，运行器在尝试执行测试体之前就会报错。

```lisp
(let ((han.test:*tests* nil))
  (han.test:run-test 'never-registered))
;; signals simple-error
```

[`deftest`](deftest.md) · [`run-all-tests`](run-all-tests.md) · [Source · 源码](../../../test/core.lisp#L58) · [Index · 索引](../README.md)
