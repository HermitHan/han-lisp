# 在程序中使用 Han

[English](README.md) · [项目总览](../../README.zh-CN.md) · [公开符号参考](../reference/README.zh-CN.md)

## 把 Han 加载到自己的程序里

在 macOS 或 Linux 上可使用 SBCL、LispWorks 或启用了 Unicode 的 ECL。使用 ECL 时，可以用 `ecl -norc` 启动 REPL。在仓库根目录下，执行 `(load "load-han.lisp")` 即可加载运行系统及七个包。如果想直接使用 ASDF，可在同一目录依次求值。

```lisp
(require :asdf)
(asdf:load-asd (truename "han.asd"))
(asdf:load-system "han")
```

在自己的 ASDF 项目里，把 `"han"` 加到系统的 `:depends-on` 列表。如果源码放在 ASDF 搜索路径之外，在当前 REPL 中先执行 `(asdf:load-asd (truename "/path/to/han-lisp/han.asd"))`，把示例路径换成本机的实际路径，再加载自己的系统。

调用函数时写出包名，例如 `han.os:run-program`。在 REPL 里可以用 `(han.os:help)` 查看已加载版本的帮助；把流参数传为 `nil`，可以只取回帮助字符串。

## 读取外部程序输出的 JSON

外部程序即使成功也可能向 stderr 写日志。分别接收两个输出流，先判断退出码，再把 stdout 送进 JSON 解析器。下面用 Unix 的 `printf` 模拟一个用 JSON 报告状态的工具。

```lisp
(multiple-value-bind (out err code)
    (han.os:run-program '("/usr/bin/printf" "%s" "{\"ready\":false}"))
  (unless (eql code 0)
    (error "Command exited with ~S: ~A" code err))
  (multiple-value-list (han.json:get-json (han.json:parse-json out) "ready")))
;; => (NIL T)
```

第二个值说明这个字段确实存在。把 JSON 换成 `"{}"` 就会得到 `(NIL NIL)`。命令采用字符串列表，每个列表元素都是单独的参数，带空格的内容也能原样传递。

## 按任务查接口

| 我想做什么 | 包手册 |
| --- | --- |
| 解析开关、位置参数或命名参数块，并报告输入错误 | [han.args](args.zh-CN.md) |
| 读取文本行、查环境变量或获取命令输出 | [han.os](os.zh-CN.md) |
| 构造路径、列举目录或复制文件 | [han.path](path.zh-CN.md) |
| 管理运行中的进程、判断终端状态或用文件锁协调写入 | [han.host](host.zh-CN.md) |
| 读取配置或写出 JSON，保留假值与空值的区别 | [han.json](json.zh-CN.md) |
| 向前查看字符、回到保存的位置或取出刚识别的一段原文 | [han.source](source.zh-CN.md) |
| 定义测试用例，用 Lisp 检查预期结果 | [han.test](test.zh-CN.md) |

各包手册列出该包的公开接口。要运行 Han 自带的测试或修改实现，请转到[开发流程](../developer/workflow.zh-CN.md)。
