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

每次改动源码，包括内部重构和错误修复，都要检查 README、文档首页、用户和开发者手册及受影响的公开符号页的两个语言版本。沿调用链检查上层包装函数。英文页使用 `.md`，简体中文页使用 `.zh-CN.md`。正文和索引链接到同一语言的页面，每页的语言链接指向该页的另一版。调用方能观察到的变化，还要用英文写入下一版 GitHub Release 正文。

1. 先用实际输入写出调用方能观察到什么。上例涉及两个返回值和一个诊断代码。面向人的提示文字可以单独调整。
2. 修改承担该行为的实现文件。新增公开接口时，在本模块的 `package.lisp` 导出符号，在中英文[用户手册](../user/README.zh-CN.md)写清调用方法，并给新行为加测试。在[公开符号参考](../reference/README.zh-CN.md)分别撰写中英文条目，从各自的包索引和字母索引链接过去。两版使用相同的签名，均给出至少两个展示不同用法的可执行示例，并保持示例代码一致。用法变化时也更新包的 REPL `help`。
3. 新增源文件时，检查 [han.asd](../../han.asd) 和 [han.dev.asd](../../han.dev.asd) 的串行组件顺序。前者要能在干净的进程中加载，后者还要加载测试文件。
4. 修改宿主操作时，同时检查 SBCL、LispWorks、ECL 和 CCL 的实现文件以及其他实现的后备入口。改进程捕获，可验证标准输出、标准错误、非零退出和资源清理；改游标移动，则可检查跨换行取字符之后能否精确回退。所选用例应当能区分本次改动可能引入的错误行为。

新增宿主时，将专属实现放进新后端，并在两个 ASDF 系统中登记。已有后端随新工作树一起回归。若发现已有后端有错，先用上一版复现，明确调用者应看到什么，再把回归用例与修复放在一起。检查进程启动时要核对实际执行了哪个文件，以及工作目录、参数、环境和退出状态。

## 从仓库运行全套测试

另起进程运行。用例会调用 Unix 工具并操作文件，需要可写的临时目录与 ASDF 缓存，以及常用的 Unix 命令。以下命令在出现失败或没有登记任何用例时返回非零退出码。

```sh
sbcl --noinform --no-sysinit --no-userinit --disable-debugger \
  --load load-han.dev.lisp \
  --eval '(multiple-value-bind (passed failed) (han.test:run-all-tests)
            (uiop:quit (if (and (plusp passed) (zerop failed)) 0 1)))'
```

使用启用了 Unicode 的 ECL 26.5.5 时，测试入口相同。ECL 通过 ASDF 进行原生编译时需要可用的 C 编译器。使用 ECL 26.5.5 自带的 ASDF 3.1.8.11 时，若为测试设置 `TMPDIR`，应传入真实存在且已消去 `..` 的绝对目录，例如从系统的常规临时目录运行 `export TMPDIR="$(mktemp -d)"`。在 Linux 上，目录名中保留 `/../` 可能导致 UIOP 创建临时文件失败。

```sh
ecl -norc -nodebug -load load-han.dev.lisp \
  -eval '(multiple-value-bind (passed failed) (han.test:run-all-tests)
           (uiop:quit (if (and (plusp passed) (zerop failed)) 0 1)))'
```

使用 CCL 1.14 时，将 `CCL_BIN` 设为完整发行目录中的内核绝对路径。Apple Silicon macOS 使用 `darm64cl`，x86-64 Linux 使用 `lx86cl64`。

```sh
"$CCL_BIN" --no-init --batch --quiet --load load-han.dev.lisp \
  --eval '(multiple-value-bind (passed failed) (han.test:run-all-tests)
            (ccl:quit (if (and (plusp passed) (zerop failed)) 0 1)))'
```

使用 LispWorks 时，在能加载 ASDF 的 REPL 中从仓库加载 `load-han.dev.lisp`，再求值 `(han.test:run-all-tests)`。返回的两个整数依次是通过数和失败数。如果系统能加载却找不到模块测试，可以对照[运行加载器](../../load-han.lisp)和[开发加载器](../../load-han.dev.lisp)。

改动可移植性边界时，在 **macOS 和 Linux 上分别用 SBCL、LispWorks、ECL 和 CCL** 验证同一份源码和回归用例。先在干净的运行镜像加载 `load-han.lisp`，再用另一个进程加载 `load-han.dev.lisp`。逐项记录操作系统版本、Lisp 版本和结果，未运行的组合标为待验。并行运行 ECL 时，为每个进程单独设置 `XDG_CACHE_HOME` 和绝对路径的 `TMPDIR`，使原生编译各自写入独立目录。

测试同步进程时，在同一台机器上直接运行同一工具，对照其正常退出时的退出码和标准错误文本。核对标准输出、标准错误、退出状态三个返回值的顺序，再以 `:ignore-error-status nil` 重跑非零退出用例，确认触发 `simple-error`。信号终止应单独测试，按对应后端沿用的信号约定断言。对于编码，比较接口承诺写出的字节。对于 pathname，比较接口承诺的组件。[可移植性边界](README.zh-CN.md#可移植性边界)

在每个受测实现中从仓库加载 `scripts/check-lock-interop.lisp`。ECL 父进程启动 SBCL；SBCL 或 LispWorks 父进程启动 ECL。CCL 父进程默认启动 SBCL。要验证与 CCL 的双向争用，用 `HAN_LOCK_PEER_IMPL` 从 `sbcl`、`ecl`、`ccl` 中选一个子进程实现，再用 `HAN_LOCK_PEER` 指定对应可执行文件的完整路径。检查使用同一锁文件，让两个进程互换持锁方和争用方，分别验证超时，再用 SIGKILL 终止持锁进程，验证重新获锁以及回调的两个返回值。

修改原子替换逻辑时，分别测试目标缺失和目标为已有文件。替换前打开旧文件并保持读取，替换后验证新文件的名称和权限，以及暂存文件名已经消失。再用另一个文件系统分别构造目标已存在和缺失的失败场景，核对源与目标均保留调用前的状态。[文件替换契约](../reference/host/atomic-replace-file.zh-CN.md) · [宿主单测](../../host/test.lisp)

## 验证可执行程序入口

运行 `python3 scripts/check-cli-boundaries.py ccl --lisp "$CCL_BIN"`，构建 Han 测试程序并从独立进程执行。其余后端将 `ccl` 换成 `sbcl`、`ecl` 或 `lispworks` 并传入对应的可执行文件。LispWorks 的独立程序测试需要带 Delivery 的版本。脚本等待程序启动后发送 SIGINT，分别制造标准输出管道的读端关闭和标准错误不可写的情况，核对退出码与两个输出通道，同时覆盖应用已明确请求非零退出码和已处理可选进度写入失败的情形。[CLI 进程测试](../../scripts/check-cli-boundaries.py)

排查长 Unicode 参数时，从父进程传参，依次比对原始 UTF-8 字节、Lisp 解码所得实参和序列化后的输出。在子进程内部构造字符串会绕过操作系统参数解码。[命令行参数契约](../reference/host/argv.zh-CN.md)

## 验证 TAFFISH 消费方

从已记录的 TAFFISH 修订建立隔离副本，应用所需的前置补丁，用候选 Han 的源码、两份 ASDF 清单、加载器及测试替换副本中的 `vendor/han`。确认 `(asdf:system-source-file "han")` 指向该副本后运行 TAFFISH 开发套件。在支持交付可执行程序的环境中，构建 `taf`、`taffish` 和 `taffish-mcp`，运行二进制外测，选取有代表性的 CLI 和 MCP 输入，与同机使用原 vendor 的 TAFFISH 对照输出、诊断及退出码。记录双方的源码修订或摘要、运行环境、失败、跳过及复跑结果。macOS LispWorks Personal 在 Listener 运行源码套件，Linux LispWorks Professional 还验证交付的二进制。

修复需要调用新增的 Han 操作时，分别验证原 vendor、仅升级 vendor 并保留原调用，以及升级 vendor 并接入新接口三种状态。例如在 Hub repair 中，TAFFISH 先由事务逻辑确认允许替换，再调用 [`atomic-replace-file`](../reference/host/atomic-replace-file.zh-CN.md)。复测同一 `journal.json` 连续更新、替换无后缀启动器、保护既有备份和目录，以及注入故障后的恢复。TAFFISH 在自己的仓库维护接入改动。

## 测量 SBCL 运行时代码覆盖率

使用新编译缓存运行 `XDG_CACHE_HOME="$(mktemp -d)" sbcl --script scripts/check-coverage.lisp /tmp/han-coverage/`。打开输出目录中的 `cover-index.html`，即可按文件查看模块测试和命令行集成测试执行了哪些表达式、走过哪些分支。[覆盖率脚本](../../scripts/check-coverage.lisp)按 `han.asd` 选取运行时文件，从系统加载完毕后开始计数。报告统计当前 SBCL 进程，CCL、ECL、LispWorks 套件和符号手册的示例进程另行运行。

## 对照网络失败和非法 UTF-8 的行为

这项可选检查可在 macOS 或 Linux 上运行，需要 Python 3、支持 Unix 套接字、HTTPS 和 DNS-over-HTTPS（DoH）的 curl，以及 `openssl` 命令行工具。默认使用 SBCL。通过 `--ccl`、`--ecl` 或 `--lispworks` 传入可执行文件即可选择批处理实现，图形界面的 LispWorks Listener 则使用 `--listener`。

```sh
python3 scripts/check-host-boundaries.py
python3 scripts/check-host-boundaries.py --ccl "$CCL_BIN"
python3 scripts/check-host-boundaries.py --ecl "$(command -v ecl)"
python3 scripts/check-host-boundaries.py --lispworks /path/to/lispworks
python3 scripts/check-host-boundaries.py --listener
```

使用 Personal Edition 时先打开新的 Listener，再在终端运行带 `--listener` 的命令。在 Listener 中求值终端打印的 `(load ...)` 表达式。保持终端运行，直至本机测试服务收到请求并输出检查结果。

脚本在同一台机器上直接运行 curl，取得退出码作为对照，再检查 `han.os:run-program`。普通模式（默认 `:ignore-error-status t`）下，这些失败场景的三个返回值依次是空的标准输出、含诊断信息的标准错误和 curl 的非零退出码。严格模式（`:ignore-error-status nil`）遇到非零退出码会发出 `simple-error`。[检查脚本](../../scripts/check-host-boundaries.py)

每行 `RESULT` 都保留两次调用的完整诊断以及 Han 在严格模式下发出的条件。比较时只忽略诊断里的耗时毫秒数，因为两次调用的耗时可以不同。两台机器连接同样不可达的代理时，也可能得到不同的本机错误。

| 场景 | 检查方式 |
| --- | --- |
| 连接和读取超时 | curl 分别尝试不可用的 Unix 套接字和没有监听者的本机回环 TCP 端口。另一个本机 HTTP 服务接受请求后不发送响应，用于验证已连接后的读取超时。 |
| DNS | curl 通过 DoH 向测试用的本机 HTTPS 服务查询保留主机名 `han-probe.invalid.`。服务明确回复 `NXDOMAIN`（该域名不存在）。只有连接这个使用自签证书的解析器时才使用 `--doh-insecure`。DNS 查询全程使用回环地址。 |
| 代理 | 显式让 curl 使用无法连接的本机回环代理，与直接运行 curl 并指定相同代理时的结果对照。 |
| TLS 信任 | 单独发起请求，验证 curl 对源站证书的检查。本机 HTTPS 服务使用临时自签证书。先验证证书检查失败，再用 `--cacert` 显式信任这张证书，向同一源站发送应当成功的请求。 |

脚本还会记录宿主 UTF-8 解码器如何处理非法续字节和文件末尾的截断序列。可根据返回的字符或条件类型，区分解码器行为和 JSON 语法错误。

在 CCL 1.14 上，探针还会断言非法续字节样本返回一个 U+FFFD，文件末尾截断的样本因字符串未闭合而触发 JSON 错误。

## 验证符号参考

在仓库根目录分别运行 `sbcl --script scripts/check-reference.lisp`、`ecl -norc -shell scripts/check-reference.lisp` 和 `"$CCL_BIN" --no-init --batch --quiet --load scripts/check-reference.lisp`。[校验脚本](../../scripts/check-reference.lisp)根据实际导出符号核对两种语言的条目，以及每个语言版本的包索引和字母索引。脚本逐对比较符号名、签名、示例代码及预期结果。每次运行校验脚本时，每个相同的示例只执行一次，由选定的 Lisp 实现另启进程加载当前仓库并运行。

校验脚本支持 SBCL、ECL 和 CCL 的批处理模式。在 LispWorks 上，从新的 Listener 或开发镜像加载当前仓库，逐一执行受影响的示例，将返回值或触发的条件与末行注释核对。个别示例还会另起 Lisp 子进程，在 ECL 和 CCL 上使用当前内核，在其他宿主上使用 `sbcl` 命令。需要可写的临时目录与 ASDF 缓存，部分示例还会调用 Unix 工具。批处理示例执行失败时输出文件、示例序号和代码块起始行，退出码非零。

每个条目的示例节至少包含两个标为 `lisp` 的代码块。选能看出行为差异的例子：例如给出一个存在但为假的字段，再查一个缺失字段；复杂接口可以接着展示错误或资源清理。示例使用自己的临时文件；在 REPL 单独复制任一块就能运行。

每个代码块的最后一行只写一种预期：

- `;; => "Ada"` 用 Common Lisp 的 `equal` 核对主返回值，字符串区分大小写。它不核对次要返回值。
- `;; => values (NIL T)` 核对全部返回值、顺序和个数。用 `values ()` 表示零个返回值，`values (NIL)` 表示一个值为 `NIL` 的返回值。
- `;; signals han.json:json-error` 要求最后一个顶层表达式触发指定类型的错误，子类型也匹配。写出具体的条件类型；正常返回或引发其他类型都会失败。把可能出错的准备步骤写成前面的顶层表达式，避免建测试数据时出错也被当成预期结果。
