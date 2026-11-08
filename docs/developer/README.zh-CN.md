# 开发 Han

[English](README.md) · [项目总览](../../README.zh-CN.md) · [修改与测试](workflow.zh-CN.md) · [公开符号参考](../reference/README.md)

Han 把命令行程序反复面对的问题放在各自的包里。决定一段新代码的归属，可以先看谁拥有它操作的数据、谁能解释结果。例如“取得子进程的退出码”由宿主层实现，“把非零退出码显示成哪句提示”由运行这个程序的应用决定。

## 系统怎样装配

[han.asd](../../han.asd) 按 `test → host → source → os → path → json → args` 串行加载运行系统。这是装配顺序。实际调用中，`han.os` 将进程操作交给 `han.host`，`han.path` 将文件系统操作交给它，`han.args` 可以从它取得当前进程的 argv。传入显式 argv 可以在 REPL 中重放命令行。JSON 解析器用字符串和整数偏移量递归下降；`han.source` 则是供解析器作者选用的独立游标。

每个包的 `package.lisp` 声明导出符号，并提供 REPL 的 `help` 与 `version`。[han.dev.asd](../../han.dev.asd) 另行列出实现文件和各包测试，并声明 UIOP 依赖。新增实现文件时要检查两份 ASDF 清单。测试框架本身属于运行系统，库自带的测试用例由开发系统登记。

## 各包的设计与边界

| 包 | 设计依据、源码位置及扩展边界 |
| --- | --- |
| [han.host](../../host/) | 对外使用同一种进程句柄和函数签名，内部保留后端的原生句柄。[common.lisp](../../host/common.lisp) 处理同步调用的输入输出准备、捕获文件和清理；[SBCL](../../host/sbcl.lisp) 与 [LispWorks](../../host/lispworks.lisp) 各自启动进程、取得状态并处理终端与文件描述符。新增需要实现专属 API 的操作应从这里开始，同时检查[其他实现的入口](../../host/unsupported.lisp)。 |
| [han.os](../../os/) | 面向“这次操作要拿到什么”。[run-shell.lisp](../../os/run-shell.lisp) 在 host 接口之上选择 shell、把输出分行或返回字符串。[io.lisp](../../os/io.lisp) 处理读取，[env.lisp](../../os/env.lisp) 处理环境与命令定位。属于某个工具的环境变量名和退出策略留在该工具中。 |
| [han.path](../../path/core.lisp) | 面向 pathname 的目录部分、名称、类型和相对关系。`directory-pathname` 可把输入解释成目录；验证目录确实存在要调用 `directory-exists-p`。拼接或规范化规则放在这里，实际探测、枚举和复制沿用 host 的实现。 |
| [han.source](../../source/char-source.lisp) | 将字符移动和位置记账放在同一处。每个游标持有输入的副本与自己的标识。标记保存索引、行、列，区间保存同一来源的起止偏移。修改跨行读取或回退时要同时检查这三项。引号、注释或其他词法规则由使用游标的解析器解释。 |
| [han.args](../../args/) | 保留规格、原始输入、绑定结果三种可单独检查的对象。分词只认识 argv 的形状，绑定才结合规格解释它，查询再解析引用型默认值。应用决定如何展示诊断、怎样从环境构造内置绑定。各步对应的文件见下例。 |
| [han.json](../../json/core.lisp) | 编解码共享一套 Lisp 表示。对象是字符串键的哈希表，数组是向量，假值是 `nil`，空值是 `:null`。查询保留存在标志，写对象时按键排序。格式错误在这一层报告为 `json-error`；“配置必须含有哪个字段”由读取该配置的应用验证。 |
| [han.test](../../test/core.lisp) | 用一个可动态绑定的用例表保存名字和函数。重新定义同名符号会替换登记项，适合在 REPL 中修改后重跑。断言和运行器归此包，具体行为的回归用例放在被测模块的 `test.lisp`，例如 [args/test.lisp](../../args/test.lisp)。 |

## 跟一次参数冲突

假设规格 `(--/-n)name=world` 只接受一个值，而用户同时传入 `-n Ada --name Lin`。两个拼法单独使用都有效。只有在对照规格之后，库才能知道它们指向同一个参数。

| 阶段 | 此例中发生的事 |
| --- | --- |
| [规格](../../args/spec.lisp) | `parse-arg-spec` 建立同一个名字的长短选项，`parse-args-spec` 汇总并检查整组规格。 |
| [分词](../../args/lexer.lisp) | `parse-args-input` 把命令名与 argv 分开，为两个选项及其值保留原文和位置。 |
| [绑定](../../args/bind.lisp) | 绑定器先复制词法诊断，再追加本阶段的诊断。本例的单值解析分支发现两个候选，产生状态为 `:conflict` 的绑定和代码为 `:conflict` 的错误诊断。 |
| [查询](../../args/query.lisp) | `get-arg` 返回 `nil` 和 `:conflict`。调用方可取 `args-result-diagnostics` 来生成界面消息，也可以在测试里直接断言诊断代码。 |

若要让一种新的选项拼法被识别，先检查分词器对该输入的分类。若要调整两个候选值之间的选择规则，改动属于绑定器。可运行的冲突例子和针对性测试见[修改与测试](workflow.zh-CN.md)。
