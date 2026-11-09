# `han.test:run-test`

[简体中文](run-test.zh-CN.md)

*Function*

## Syntax

```text
(han.test:run-test name) → passed-p
```

## Description

Find a registered test by symbol identity and run it with zero arguments. Normal return prints a pass line and returns `t`, even if the body returned `nil`. An error raised within the test prints a failure line and returns `nil`. An unregistered name signals an error before the test handler is entered.

## Examples

Run a named case that checks the first element of an empty list.

```lisp
(let ((han.test:*tests* nil))
  (han.test:deftest empty-input () (han.test:check-false (first '())))
  (han.test:run-test 'empty-input))
;; => T
```

A failing assertion returns a false test result to the runner’s caller.

```lisp
(let ((han.test:*tests* nil)
      (*standard-output* (make-broadcast-stream)))
  (han.test:deftest short-record () (han.test:check-equal 2 (length '(a))))
  (han.test:run-test 'short-record))
;; => NIL
```

An unknown test name signals an error before the runner can invoke a test body.

```lisp
(let ((han.test:*tests* nil))
  (han.test:run-test 'never-registered))
;; signals simple-error
```

[`deftest`](deftest.md) · [`run-all-tests`](run-all-tests.md) · [Source](../../../test/core.lisp#L58) · [Index](../README.md)
