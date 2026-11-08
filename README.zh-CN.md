# Han Lisp

[English](README.md)

Han 是一个用于编写命令行工具的 Common Lisp 基础库。通过 ASDF 系统 `han` 可以加载命令行参数解析、子进程输入输出、路径处理和 JSON 等功能。它源自 TAFFISH，可以在其他项目中独立使用。

## 加载

在仓库根目录启动 Lisp REPL，加载本地源码。

```lisp
(load "load-han.lisp")
```

加载脚本会将本仓库加入 ASDF 的搜索路径，并加载 `han`。如果 ASDF 已经能发现本仓库，执行 `(require :asdf)` 后即可使用 `(asdf:load-system "han")`。宿主适配层有 SBCL 和 LispWorks 两套实现。在其他 Lisp 实现上调用需要宿主适配的操作时，会收到错误。

## 在 REPL 中使用

`get-json` 返回两个值，可以据此区分值为 `false` 的 JSON 字段和缺失的字段。

```lisp
(let ((config (han.json:parse-json "{\"enabled\":false}")))
  (list (multiple-value-list (han.json:get-json config "enabled"))
        (multiple-value-list (han.json:get-json config "missing"))))
;; => ((NIL T) (NIL NIL))
```

每个包都提供 `help` 函数。例如，`(han.args:help)` 可以查看参数规格的写法。

| 包 | 用途 |
| --- | --- |
| `han.args` | 解析参数规格、绑定命令行参数并查询结果 |
| `han.host` | 通过当前 Lisp 实现访问系统进程、环境变量、终端和文件 |
| `han.os` | 读取流、查找可执行文件和运行 shell 命令 |
| `han.path` | 拼接路径、取父目录和计算相对路径 |
| `han.json` | 解析和编码 JSON，读写 JSON 文件 |
| `han.source` | 用游标扫描文本，为解析器记录位置和区间 |
| `han.test` | 定义测试、断言和运行测试套件 |

## 运行测试

在仓库根目录新启动一个 SBCL 进程，加载开发系统 `han.dev`。测试使用 ASDF 自带的 UIOP，需要可写的临时目录、Unix shell 及常用系统命令，并要求已设置 `USER` 环境变量。如果有测试失败或测试总数为零，以下命令以状态码 1 退出。

```sh
sbcl --noinform --no-sysinit --no-userinit --disable-debugger \
  --load load-han.dev.lisp \
  --eval '(multiple-value-bind (passed failed) (han.test:run-all-tests)
            (uiop:quit (if (and (plusp passed) (zerop failed)) 0 1)))'
```

## 来源与许可

本仓库最初的源码取自 [TAFFISH 提交 `4697321` 的 `vendor/han` 目录](https://github.com/taffish/taffish/tree/4697321b9b8570e5b9862423c62620191bd21522/vendor/han)。Han 采用 [MIT 许可证](LICENSE)。
