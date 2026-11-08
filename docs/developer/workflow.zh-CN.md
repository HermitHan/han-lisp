# 修改与测试

[English](workflow.md) · [架构与包的边界](README.zh-CN.md)

## 在 REPL 里重现行为

在仓库根目录启动新的 Lisp 进程，求值 `(load "load-han.dev.lisp")`，即可加载开发系统并登记模块测试。本机装有另一份 `han` 时，用新进程可以避开已有的包和测试状态。用 `(asdf:system-source-file "han.dev")` 可以检查 ASDF 实际选中了哪个系统文件。

下面把[重复选项](README.zh-CN.md)写成一个定向测试，分别检查应用读到的值和可以报告的诊断。局部绑定 `*tests*`，在 REPL 试这个例子时就能保留原有用例表。

```lisp
(let ((han.test:*tests* nil))
  (han.test:deftest duplicate-name ()
    (let* ((spec (han.args:parse-args-spec
                  (list (han.args:parse-arg-spec "(--/-n)name=world"))
                  "greet"))
           (input (han.args:parse-args-input '("greet" "-n" "Ada" "--name" "Lin")))
           (result (han.args:bind-args spec input)))
      (han.test:check-equal '(nil :conflict)
                            (multiple-value-list (han.args:get-arg "name" result)))
      (let ((diagnostic (find :conflict (han.args:args-result-diagnostics result)
                              :key #'han.args:arg-diagnostic-code)))
        (han.test:check-true diagnostic)
        (han.test:check-equal :error (han.args:arg-diagnostic-kind diagnostic)))))
  (han.test:run-test 'duplicate-name))
;; => T
```

如果要把这样的回归用例加入库中，将 `deftest` 表达式放在 [args/test.lisp](../../args/test.lisp) 的绑定测试旁。测试名属于该文件所在的包，在同一个包中用 `(han.test:run-test 'duplicate-name)` 即可按符号运行它。在 REPL 中重新求值测试定义，再运行它，就能看到修改结果。

## 在负责这项行为的模块里修改

1. 先用实际输入写出调用方能观察到什么。上例涉及两个返回值和一个诊断代码。面向人的提示文字可以单独调整。
2. 修改承担该行为的实现文件。新增公开接口时，在本模块的 `package.lisp` 导出符号，在中英文[用户手册](../user/README.zh-CN.md)写清调用方法，并给新行为加测试。在[公开符号参考](../reference/README.md)新增独立条目，为不同用法写至少两个可以执行的例子，并从包索引和字母索引链接过去。用法变化时也更新包的 REPL `help`。
3. 新增源文件时，检查 [han.asd](../../han.asd) 和 [han.dev.asd](../../han.dev.asd) 的串行组件顺序。前者要能在干净的进程中加载，后者还要加载测试文件。
4. 修改宿主操作时，同时检查 SBCL、LispWorks 的实现文件以及其他实现的后备入口。改进程捕获，可验证标准输出、标准错误、非零退出和资源清理；改游标移动，则可检查跨换行取字符之后能否精确回退。所选用例应当能区分本次改动可能引入的错误行为。

## 从仓库运行全套测试

另起进程运行。用例会调用 Unix 工具并操作文件，需要可写的临时目录与 ASDF 缓存、常用 shell 命令以及已设置的 `USER` 环境变量。以下命令在出现失败或没有登记任何用例时返回非零退出码。

```sh
sbcl --noinform --no-sysinit --no-userinit --disable-debugger \
  --load load-han.dev.lisp \
  --eval '(multiple-value-bind (passed failed) (han.test:run-all-tests)
            (uiop:quit (if (and (plusp passed) (zerop failed)) 0 1)))'
```

使用 LispWorks 时，在能加载 ASDF 的 REPL 中从仓库加载 `load-han.dev.lisp`，再求值 `(han.test:run-all-tests)`。返回的两个整数依次是通过数和失败数。验证宿主改动时，请记录实际运行的操作系统和 Lisp 实现，其余组合单列为待验。如果系统能加载却找不到模块测试，可以对照[运行加载器](../../load-han.lisp)和[开发加载器](../../load-han.dev.lisp)。

## 验证符号参考

在仓库根目录运行 `sbcl --script scripts/check-reference.lisp`。[校验脚本](../../scripts/check-reference.lisp)比对实际导出符号、参考页和两份索引，然后从 Markdown 逐块取出示例，每块另启一个 SBCL 进程加载当前仓库。命令需要可写的临时目录与 ASDF 缓存，部分示例还会调用 Unix 工具。失败时输出文件、示例序号和代码块起始行，退出码非零。

每个条目的示例节至少包含两个标为 `lisp` 的代码块。选能看出行为差异的例子：例如给出一个存在但为假的字段，再查一个缺失字段；复杂接口可以接着展示错误或资源清理。示例使用自己的临时文件；在 REPL 单独复制任一块就能运行。

每个代码块的最后一行只写一种预期：

- `;; => "Ada"` 用 Common Lisp 的 `equal` 核对主返回值，字符串区分大小写。它不核对次要返回值。
- `;; => values (NIL T)` 核对全部返回值、顺序和个数。用 `values ()` 表示零个返回值，`values (NIL)` 表示一个值为 `NIL` 的返回值。
- `;; signals han.json:json-error` 要求最后一个顶层表达式触发指定类型的错误，子类型也匹配。写出具体的条件类型；正常返回或引发其他类型都会失败。把可能出错的准备步骤写成前面的顶层表达式，避免建测试数据时出错也被当成预期结果。
