# `han.test:deftest`

*Macro · 宏*

## Syntax · 语法

```text
(han.test:deftest name lambda-list form*) → name
```

## Description · 说明

Register the body under the literal symbol `name` and return that symbol. The body runs later when selected by a runner. Give it an empty parameter list because runners call the function with zero arguments. Registering the same symbol again replaces its previous case and moves it to the newest registration position.

用字面符号 `name` 登记测试体并返回该符号，测试体在运行器选中它时才执行。运行器以零参数调用测试，通常应使用空参数表。同一符号再次登记时会替换前一用例，并成为最新登记项。

## Examples · 示例

Redefine a case under the same symbol, then run the replacement.

使用同一符号重新定义用例，再运行新定义。

```lisp
(let ((han.test:*tests* nil))
  (han.test:deftest total () (han.test:check-equal 2 (+ 1 1)))
  (han.test:deftest total () (han.test:check-equal 3 (+ 1 2)))
  (list (length han.test:*tests*) (han.test:run-test 'total)))
;; => (1 T)
```

Registration records the body for later execution. Watch a lexical counter as the test is defined and then run.

登记只保存测试体。通过词法计数器观察定义时和运行后的变化。

```lisp
(let ((han.test:*tests* nil) (calls 0))
  (han.test:deftest count-calls () (incf calls))
  (list calls (han.test:run-test 'count-calls) calls))
;; => (0 T 1)
```

[`run-test`](run-test.md) · [`*tests*`](var-tests.md) · [Source · 源码](../../../test/core.lisp#L13) · [Index · 索引](../README.md)
