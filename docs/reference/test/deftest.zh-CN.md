# `han.test:deftest`

[English](deftest.md)

*宏*

## 语法

```text
(han.test:deftest name lambda-list form*) → name
```

## 说明

用字面符号 `name` 登记测试体并返回该符号，测试体在运行器选中它时才执行。运行器以零参数调用测试，通常应使用空参数表。同一符号再次登记时会替换前一用例，并成为最新登记项。

## 示例

使用同一符号重新定义用例，再运行新定义。

```lisp
(let ((han.test:*tests* nil))
  (han.test:deftest total () (han.test:check-equal 2 (+ 1 1)))
  (han.test:deftest total () (han.test:check-equal 3 (+ 1 2)))
  (list (length han.test:*tests*) (han.test:run-test 'total)))
;; => (1 T)
```

登记只保存测试体。通过词法计数器观察定义时和运行后的变化。

```lisp
(let ((han.test:*tests* nil) (calls 0))
  (han.test:deftest count-calls () (incf calls))
  (list calls (han.test:run-test 'count-calls) calls))
;; => (0 T 1)
```

[`run-test`](run-test.zh-CN.md) · [`*tests*`](var-tests.zh-CN.md) · [源码](../../../test/core.lisp#L13) · [索引](../README.zh-CN.md)
