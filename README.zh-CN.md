# Han Lisp

[English](README.md) · [用户手册](docs/user/README.zh-CN.md) · [开发者手册](docs/developer/README.zh-CN.md) · [公开符号参考](docs/reference/README.md)

Han 是一个 Common Lisp 基础库。写命令行工具时，我们常常需要解释一组参数、找文件、启动另一个程序，再把结果写成 JSON。Han 把这些可以在项目之间复用的工作组织成一个 ASDF 系统 `han`，让应用专心定义自己的行为。它最初在 TAFFISH 的开发中形成，可以独立加载。

## 设计取舍

- **应用决定如何回应用户。** 参数绑定器可以指出缺了哪个必填项。怎样提示、用哪种语言、程序应当以什么状态退出，由调用方决定。
- **返回值保留下一步判断需要的信息。** 运行子进程可以分别拿到标准输出、标准错误和退出码。查询 JSON 字段可以同时拿到字段值和存在标志，从而区分“显式设为假”和“没有配置”。
- **把实现差异收在宿主层。** SBCL 与 LispWorks 获取进程句柄、配置终端流的方式不同，`han.host` 为上层提供共同的调用接口。运行系统没有声明第三方 Lisp 库依赖。

## 加载并试用

克隆[这个仓库](https://github.com/HermitHan/han-lisp)，从仓库根目录启动 Lisp REPL。下面的小例子读取命令行上的名字，返回一段 JSON。

```lisp
(load "load-han.lisp")

(let* ((option (han.args:parse-arg-spec "(--/-n)name=world"))
       (spec (han.args:parse-args-spec (list option) "greet"))
       (input (han.args:parse-args-input '("greet" "-n" "Ada")))
       (result (han.args:bind-args spec input)))
  (han.json:encode-json
   (han.json:json-object (cons "hello" (han.args:get-arg "name" result)))
   :indent nil))
;; => "{\"hello\":\"Ada\"}"
```

把输入换成只有命令名的 `'("greet")`，同一份规格就会给出默认值 `"world"`。处理用户实际传入的 argv 时，要先检查 `args-result-diagnostics` 中有无错误，再使用参数值。两种写法同时出现时的结果见[参数冲突示例](docs/developer/README.zh-CN.md)。

ASDF 能找到本仓库后，其他系统可以通过 `:depends-on ("han")` 引用它。[加载和日常使用](docs/user/README.zh-CN.md)

## 包与分工

| 包 | 它负责的事 |
| --- | --- |
| [han.args](docs/user/args.zh-CN.md) | 声明命令行参数，保留输入位置，绑定参数值并返回诊断 |
| [han.os](docs/user/os.zh-CN.md) | 读取流和文件、查环境变量、运行外部命令 |
| [han.path](docs/user/path.zh-CN.md) | 构造、解析和检查路径，操作文件和目录 |
| [han.host](docs/user/host.zh-CN.md) | 适配 SBCL 和 LispWorks，管理进程句柄、终端 I/O 和文件锁 |
| [han.json](docs/user/json.zh-CN.md) | 在 JSON 和 Lisp 值之间转换，查询对象，读写 JSON 文件 |
| [han.source](docs/user/source.zh-CN.md) | 在字符串上移动游标、保存位置、取出解析器识别的一段原文 |
| [han.test](docs/user/test.zh-CN.md) | 定义测试、检查预期值、运行已登记的用例 |

## 运行测试

在新的 Lisp 进程加载开发系统 `han.dev`，即可登记库自带的测试。开发者手册提供[完整测试命令](docs/developer/workflow.zh-CN.md)和[源码结构与包的边界](docs/developer/README.zh-CN.md)。

## 来源与许可

独立仓库的首个版本取自 [TAFFISH v0.11.0 的 Han 源码](https://github.com/taffish/taffish/tree/4697321b9b8570e5b9862423c62620191bd21522/vendor/han)。Han 采用 [MIT 许可证](LICENSE)。
