# 开发 Han

[English](README.md) · [项目总览](../../README.zh-CN.md) · [修改与测试](workflow.zh-CN.md) · [公开符号参考](../reference/README.md)

Han 把命令行程序反复面对的问题放在各自的包里。决定一段新代码的归属，可以先看谁拥有它操作的数据、谁能解释结果。例如“取得子进程的退出码”由宿主层实现，“把非零退出码显示成哪句提示”由运行这个程序的应用决定。

## 系统怎样装配

[han.asd](../../han.asd) 按 `test → host → source → os → path → json → args` 串行加载运行系统。这是装配顺序。实际调用中，`han.os` 将进程操作交给 `han.host`，`han.path` 将文件系统操作交给它，`han.args` 可以从它取得当前进程的 argv。传入显式 argv 可以在 REPL 中重放命令行。JSON 解析器用字符串和整数偏移量递归下降；`han.source` 则是供解析器作者选用的独立游标。

每个包的 `package.lisp` 声明导出符号，并提供 REPL 的 `help` 与 `version`。[han.dev.asd](../../han.dev.asd) 另行列出实现文件和各包测试，并声明 UIOP 依赖。新增实现文件时要检查两份 ASDF 清单。测试框架本身属于运行系统，库自带的测试用例由开发系统登记。

## 可移植性边界

除 `han.host` 外，六个运行时包共用一套 ANSI Common Lisp 实现。读入期条件分支、具体实现的包和操作系统约定都放在[宿主层](../../host/)；两份 ASDF 清单的条件分支只选择宿主文件。标准 CL 已经定义、且含义由本包决定的操作可以留在本包，例如输出 JSON、拼接 pathname 组件，或在写 JSON 文件前要求建立父目录。审查时先问两件事：**谁定义这条规则？调用方可以依赖什么？**

| 操作 | 上层保证 | 宿主职责与保留的差异 |
| --- | --- | --- |
| JSON 与 UTF-8 文件 | [JSON 包](../../json/core.lisp)负责 ASCII 语法、转义、代理对和十进制数。[文本读取](../../os/io.lisp)也接受调用方已经打开的字符流。 | [字符映射](../../host/characters.lisp)只转换可表示的 Unicode 标量；非法转义和无法映射的字符在 JSON 层发出 `han.json:json-error`。[UTF-8 文件入口](../reference/host/with-open-utf8-file.md)指定外部编码；传入的流沿用自身编码。非法文件字节由流解码器处理。浮点数的精度以及合法的输出写法可以因实现而异。 |
| 程序查找与 shell 选择 | [han.os](../../os/)决定调用方得到文本、行列表还是进程句柄。显式传入 argv 列表时，各参数按原值传递。 | [程序查找](../reference/host/find-executable.md)负责 Unix 的 PATH 分隔符、空条目和备用目录，按顺序返回不同的已有文件；执行权限由操作系统在启动时判定。[shell 参数构造](../reference/host/shell-command-argv.md)负责选取 shell 和传入 `-c`。本机 PATH、安装的软件和实际 shell 的行为都可能不同。 |
| 工作目录与路径 | [han.path](../../path/core.lisp)按 pathname 组件拼接、比较路径；字符串形式的目录组件表示一级绝对目录。 | 相对路径需要默认基准时，以及内部辅助函数构造 `*WORKDIR*` 绑定时，都会[取得工作目录 pathname](../reference/host/working-directory-pathname.md)，失败会报错；[cwd](../reference/host/cwd.md)则返回名称字符串或 `nil`。若逻辑路径需要上行，[relative-path](../reference/path/relative-path.md) 返回绝对目标。原生路径拼写、通配支持以及目录实际内容取决于宿主。 |
| 同步命令 | 使用默认捕获设置时，`han.os:run-program` 依次返回标准输出、标准错误和退出状态。默认模式返回非零状态，严格模式（`:ignore-error-status nil`）遇到非零状态会触发 `simple-error`。以 argv 直接指定程序时，启动失败在两种模式下都会报错。 | Han 保留工具正常退出时给出的退出码和写到标准错误的文本。同一操作在不同系统上可以产生不同的退出码或诊断。[同步进程契约](../reference/host/run-program-sync.md) |
| 运行中进程与信号 | 读取最终退出状态前，先等待子进程结束。被信号终止会得到非零状态，同样适用严格模式的错误规则。 | 信号终止沿用原有约定，SBCL 返回信号编号，LispWorks 返回 128 加该编号（SIGTERM 对应 15 和 143）。查询运行中进程时，SBCL 将暂停状态报告为 `:unknown`，LispWorks 在取得退出码之前报告为 `:running`。[退出状态](../reference/host/process-exit-code.md) · [即时状态](../reference/host/process-status.md) |

新增后端时，能实现同一操作，就应保留原有返回值、返回值个数和错误行为。对调用方可见的限制，要写入对应符号页，并用测试验证调用方依赖的保证。维护者的测试目标是在 macOS 和 Linux 上分别运行 SBCL 与 LispWorks，共四种系统与 Lisp 组合。其他 Lisp 实现遇到没有适配器的操作时走备用入口。shell 助手采用 Unix 约定，文件锁依赖 macOS 或 Linux 的 `flock`。[测试流程](workflow.zh-CN.md#从仓库运行全套测试) · [备用入口](../../host/unsupported.lisp) · [文件锁](../reference/host/call-with-exclusive-file-lock.md)

## 各包的设计与边界

| 包 | 设计依据、源码位置及扩展边界 |
| --- | --- |
| [han.host](../../host/) | 对外使用同一种进程句柄和函数签名，内部保留后端的原生句柄。[common.lisp](../../host/common.lisp) 处理同步调用的输入输出准备、捕获文件和清理；[SBCL](../../host/sbcl.lisp) 与 [LispWorks](../../host/lispworks.lisp) 各自启动进程、取得状态并处理终端与文件描述符。新增需要实现专属 API 的操作应从这里开始，同时检查[其他实现的入口](../../host/unsupported.lisp)。 |
| [han.os](../../os/) | 面向“这次操作要拿到什么”。[run-shell.lisp](../../os/run-shell.lisp) 调用宿主层选择的 shell，把输出分行或返回字符串。[io.lisp](../../os/io.lisp) 处理读取，[env.lisp](../../os/env.lisp) 处理环境与命令定位。属于某个工具的环境变量名和退出策略留在该工具中。 |
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
