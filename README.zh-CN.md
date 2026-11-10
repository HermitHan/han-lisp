# Han Lisp

[English](README.md) · [文档](docs/README.zh-CN.md) · [快速开始](#加载并试用) · [设计哲学](#设计哲学) · [包与分工](#包与分工)

Han 是一个用于编写命令行工具的 Common Lisp 基础库。从解析参数、定位输入文件，到启动子进程、读取它输出的 JSON，这些常用操作都可以交给 Han。七个包通过一个 ASDF 系统 `han` 一起加载。

## 文档

- **[用户手册](docs/user/README.zh-CN.md)** 介绍怎样在自己的项目里加载 Han，以及怎样组合使用各个包，例如读取外部命令输出的 JSON。
- **[公开符号参考](docs/reference/README.zh-CN.md)** 可以按包浏览，也可以用[字母索引](docs/reference/symbols.zh-CN.md)按名称查找。每个条目都说明用法，附有能在 REPL 里运行的示例。函数条目还说明参数和返回值。通过语言链接可以打开同一条目的英文版。
- **[开发者手册](docs/developer/README.zh-CN.md)** 说明七个包怎样协作，并用一次命令行参数冲突演示怎样从行为找到源码、确定该改哪个包。具体的修改和验证步骤见[开发流程](docs/developer/workflow.zh-CN.md)。

## 加载并试用

这份源码已在 Apple Silicon macOS 和 x86-64 Linux 上分别用 SBCL、LispWorks、启用 Unicode 的 ECL 26.5.5 和 64 位 Clozure CL（CCL）1.14 验证。v0.2.0 已支持 ECL，CCL 适配和 `han.host:atomic-replace-file` 从 v0.3.0 开始提供。项目固定使用 v0.2.0 时，请查阅[该标签的文档](https://github.com/HermitHan/han-lisp/blob/v0.2.0/docs/README.zh-CN.md)。

从 [GitHub Releases](https://github.com/HermitHan/han-lisp/releases) 下载并解压所选版本的源码，也可以使用已有的源码目录。在 `han.asd` 所在目录启动 REPL 并加载 Han。下面以 SBCL 为例，其他实现的启动方式见用户手册。[各实现的加载方法](docs/user/README.zh-CN.md#把-han-加载到自己的程序里)

```sh
sbcl --load load-han.lisp
```

在 REPL 里读一份配置。它明确关闭了重试，但没有指定超时时间。用 `multiple-value-list` 可以一起看到每次查询的两个返回值。

```lisp
(defparameter *settings* (han.json:parse-json "{\"retry\":false}"))

(multiple-value-list (han.json:get-json *settings* "retry"))
;; => (NIL T)

(multiple-value-list (han.json:get-json *settings* "timeout"))
;; => (NIL NIL)
```

`get-json` 返回字段的值以及键是否存在。两次查询的第一个值都是 `NIL`，第二个值则区分了“显式设为假”和“没有设置”。

要在自己的 ASDF 系统中使用 Han，让 ASDF 能找到本仓库，再把 `"han"` 加入系统的 `:depends-on` 列表。[在程序中加载 Han](docs/user/README.zh-CN.md#把-han-加载到自己的程序里)

## 设计哲学

除 `han.host` 外，六个运行时包在所有平台和 Lisp 实现上共用一套 ANSI Common Lisp 源码。实现专属调用、操作系统约定，以及 `#+`、`#-` 这类平台或实现条件分支，统一放在 `han.host`。ASDF 选择 SBCL、LispWorks、ECL 或 CCL 适配器。例如，`han.json` 负责解析四位十六进制数、合并代理对；把所得 Unicode 标量映射为 Lisp 字符、以 UTF-8 打开文件，则是宿主层的职责。

Han 明确调用方可以依赖的行为。例如，`han.path:->namestring` 返回文件名字符串，宿主无法表示该 pathname 时发出文件错误。CLI 请求成功退出时，若刷新标准输出失败，退出码改为 1。程序查找仍遵循本机的搜索顺序，子进程的最终状态需等它结束后获取。具体保证见[开发者手册的可移植性边界](docs/developer/README.zh-CN.md#可移植性边界)。

每新增一种宿主实现，就与已有后端一起回归。调整已有后端时，先复现具体缺陷。交付前还会把候选 Han 源码放进 TAFFISH 副本的 `vendor/han`，验证实际调用效果。[开发流程](docs/developer/workflow.zh-CN.md#验证-taffish-消费方)

## 包与分工

| 包手册 | 负责的事 | 示例条目 |
| --- | --- | --- |
| [`han.args`](docs/user/args.zh-CN.md) | 声明选项与位置参数，绑定输入并检查诊断信息。 | [`get-arg`](docs/reference/args/get-arg.zh-CN.md) |
| [`han.path`](docs/user/path.zh-CN.md) | 构造路径、列举目录、复制文件。 | [`join-path`](docs/reference/path/join-path.zh-CN.md) |
| [`han.os`](docs/user/os.zh-CN.md) | 读取文本、查询环境变量、获取外部命令的输出。 | [`run-program`](docs/reference/os/run-program.zh-CN.md) |
| [`han.host`](docs/user/host.zh-CN.md) | 管理子进程、查询终端状态、为文件加锁或原子替换文件。 | [`atomic-replace-file`](docs/reference/host/atomic-replace-file.zh-CN.md) |
| [`han.json`](docs/user/json.zh-CN.md) | 解析和写出 JSON，按键查询对象字段。 | [`get-json`](docs/reference/json/get-json.zh-CN.md) |
| [`han.source`](docs/user/source.zh-CN.md) | 编写文本解析器时移动字符游标、保存位置、截取原文。 | [`source-reset`](docs/reference/source/source-reset.zh-CN.md) |
| [`han.test`](docs/user/test.zh-CN.md) | 定义用例、编写断言、运行已登记的测试。 | [`deftest`](docs/reference/test/deftest.zh-CN.md) |

## 运行测试

- **库测试。** 在仓库根目录启动新的 REPL，加载 `load-han.dev.lisp`，再调用 `(han.test:run-all-tests)`。[终端命令与运行条件](docs/developer/workflow.zh-CN.md#从仓库运行全套测试)
- **参考示例。** 在仓库根目录运行校验器，核对导出符号并执行参考页的示例。SBCL 用 `sbcl --script scripts/check-reference.lisp`，ECL 用 `ecl -norc -shell scripts/check-reference.lisp`，CCL 用 `"$CCL_BIN" --no-init --batch --quiet --load scripts/check-reference.lisp`，其中 `CCL_BIN` 指向内核。[示例的校验方式](docs/developer/workflow.zh-CN.md#验证符号参考)

## 来源与许可

Han 最初是 TAFFISH 的 `vendor/han` 基础库。独立项目以 [TAFFISH v0.11.0 中的源码](https://github.com/taffish/taffish/tree/4697321b9b8570e5b9862423c62620191bd21522/vendor/han) 为起点，采用 [MIT 许可证](LICENSE)。
