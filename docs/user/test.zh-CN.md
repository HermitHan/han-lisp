# han.test · 注册和运行测试

[用户手册](README.zh-CN.md) · [English](test.md) · [本包符号参考](../reference/README.md#test)

`han.test` 用符号为测试命名，把测试登记到当前 Lisp 进程中，供调用方执行。运行系统 `han` 已包含测试框架，应用可以用它写自己的测试。开发系统 `han.dev` 还会加载 Han 各模块的测试用例。

## 测试函数的返回值约定

配置读取有时需要检查一次查询的两个返回值。下面的测试检查读取函数能否识别用户显式设置的假值，并将它和字段缺失区分开来。

```lisp
(let ((han.test:*tests* nil))
  (han.test:deftest explicit-false ()
    (let ((config (han.json:parse-json "{\"retry\":false}")))
      (multiple-value-bind (value present-p)
          (han.json:get-json config "retry")
        (han.test:check-true present-p)
        (han.test:check-false value))))
  (han.test:run-test 'explicit-false))
;; 打印一行 [PASS] 并返回 T。
```

`let` 为示例绑定一份独立的注册表，退出时原注册表自动恢复。为应用组织测试套件时，在同一份注册表中执行 `deftest` 与运行测试的函数即可。用空参数表定义测试，因为运行器调用每个测试时都传零个参数。在 REPL 重新求值同一符号的测试定义会替换旧定义。跨包调用 `run-test` 时，要传入当初定义测试的那个包中的符号。

测试体只要正常返回，就记为通过，即便最后一个表达式返回 `nil`。需要检验的结果都要写成断言。`check-equal` 采用 Common Lisp 的 `equal`，适合比较列表和字符串。比较一般向量的内容，可以把 `equalp` 放入 `check-true`，也可以先将元素转成列表再比较。

## 检查特定错误

验证输入格式错误时，用调用方实际处理的条件类型编写断言。运行整个套件可以分别取得通过数与失败数。

```lisp
(let ((han.test:*tests* nil))
  (han.test:deftest reject-trailing-comma ()
    (han.test:check-error (han.json:json-error)
      (han.json:parse-json "[1,]")))
  (multiple-value-list (han.test:run-all-tests)))
;; => (1 0)
```

如果只需确认发生了错误，可以直接用 `(check-error (error) ...)`。测试体正常返回时，断言仍会失败。

## 在脚本中运行

`run-all-tests` 报告测试计数，由调用方决定进程退出码。CI 脚本可要求通过数大于零且失败数为零。运行 Han 自身套件的命令见[开发流程](../developer/workflow.zh-CN.md)。在交互进程中，若其他项目也注册了测试，应留意清空共享注册表的影响。

| 导出名 | 行为 |
| --- | --- |
| [`*tests*`](../reference/test/var-tests.md) | 保存当前注册表的特殊变量。通过 `let` 将其绑定为 `nil`，可隔离一组测试。 |
| [`(reset-tests)`](../reference/test/reset-tests.md) | 清空当前注册表并返回 `t`。 |
| [`(deftest name () &body body)`](../reference/test/deftest.md) | 宏。以给定符号为名注册测试，返回该符号。 |
| [`(run-test name)`](../reference/test/run-test.md) | 按符号运行一个已注册的测试并打印结果。通过时返回 `t`，测试体报错时返回 `nil`。查询未注册的名称会向调用方发出错误。 |
| [`(run-all-tests)`](../reference/test/run-all-tests.md) | 按注册顺序运行当前注册表中的测试，打印每项结果及汇总，依次返回通过数、失败数两个整数。空套件返回两个零。 |
| [`(check-true form)`](../reference/test/check-true.md)、[`(check-false form)`](../reference/test/check-false.md) | 宏。分别要求表达式的主值为非 `nil` 或 `nil`。成功返回 `t`，失败发出错误。 |
| [`(check-equal expected form)`](../reference/test/check-equal.md) | 宏。两个表达式各求值一次，用 `equal` 比较主值，成功返回 `t`，失败发出错误。要检查多个返回值时，可先用 `multiple-value-list` 收集。 |
| [`(check-error (condition-type) &body body)`](../reference/test/check-error.md) | 宏。捕获到给定类型的条件时返回 `t`，测试体发出的其他类型错误继续向外传递。 |
| [`(help &optional stream)`](../reference/test/help.md)、[`(version &optional stream)`](../reference/test/version.md) | 返回帮助或版本字符串，默认也打印到标准输出。传入 `nil` 时只返回字符串，传入流则另向该流打印。 |

[导出声明](../../test/package.lisp) · [运行器与断言实现](../../test/core.lisp) · [测试套件示例](../../json/test.lisp)
