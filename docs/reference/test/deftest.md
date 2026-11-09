# `han.test:deftest`

[简体中文](deftest.zh-CN.md)

*Macro*

## Syntax

```text
(han.test:deftest name lambda-list form*) → name
```

## Description

Register the body under the literal symbol `name` and return that symbol. The body runs later when selected by a runner. Give it an empty parameter list because runners call the function with zero arguments. Registering the same symbol again replaces its previous case and moves it to the newest registration position.

## Examples

Redefine a case under the same symbol, then run the replacement.

```lisp
(let ((han.test:*tests* nil))
  (han.test:deftest total () (han.test:check-equal 2 (+ 1 1)))
  (han.test:deftest total () (han.test:check-equal 3 (+ 1 2)))
  (list (length han.test:*tests*) (han.test:run-test 'total)))
;; => (1 T)
```

Registration records the body for later execution. Watch a lexical counter as the test is defined and then run.

```lisp
(let ((han.test:*tests* nil) (calls 0))
  (han.test:deftest count-calls () (incf calls))
  (list calls (han.test:run-test 'count-calls) calls))
;; => (0 T 1)
```

[`run-test`](run-test.md) · [`*tests*`](var-tests.md) · [Source](../../../test/core.lisp#L13) · [Index](../README.md)
