# han.host

[用户手册](README.zh-CN.md) · [English](host.md) · [本包符号参考](../reference/README.zh-CN.md#host)

需要控制子进程、查询进程是否连接终端，或用系统文件锁协调多个写入者时，使用 `han.host`。它提供 SBCL、LispWorks 和启用了 Unicode 的 ECL 的宿主适配。日常执行命令和拼接路径可分别从 [han.os](os.zh-CN.md) 和 [han.path](path.zh-CN.md) 入手。下文省略包名前缀的符号均属于 `han.host`。

## 运行子进程

需要命令的最终结果时，将程序和参数放在一个非空字符串列表里。可以分别捕获标准输出和标准错误，从第三返回值取得退出码。

```lisp
(multiple-value-list
 (han.host:run-program-sync
  '("/bin/sh" "-c" "printf result; printf detail >&2; exit 7")))
;; => ("result" "detail" 7)
```

需要在子进程运行时读数据，则传入已有可执行文件路径和参数列表，从进程句柄取流，最后等待结束。示例子进程只向标准输出写一条短消息，标准错误没有数据。

```lisp
(let ((child (han.host:run-program "/bin/sh"
                                   :arguments '("-c" "printf ready"))))
  (unwind-protect
       (let ((message (read-line (han.host:host-process-output-stream child) nil)))
         (han.host:process-wait child)
         (list message (han.host:process-exit-code child)))
    (han.host:process-close child)))
;; => ("ready" 0)
```

| 操作 | 用法与返回值 |
| --- | --- |
| [`run-program-sync command &key input (output :string) (error-output :string) (ignore-error-status t)`](../reference/host/run-program-sync.zh-CN.md) | 等待命令结束。列表直接传入程序和参数，字符串作为 shell 命令。两个捕获通道分别返回字符串，第三值是正常退出时的整数状态码。传 `:ignore-error-status nil` 时，非零整数退出码会触发错误。 |
| [`run-program program &key arguments input directory environment`](../reference/host/run-program.zh-CN.md) | 启动子进程并返回 [`host-process`](../reference/host/host-process.zh-CN.md)。`program` 必须指向已有文件，需要按名称查找程序时可用 `han.os:find-executable`。传 `directory` 可使子进程在指定的已有目录运行，父进程保留原工作目录。省略 `environment` 会继承父环境，显式传入时各宿主接受的形式见符号页。 |
| [`process-status process`](../reference/host/process-status.zh-CN.md)、[`process-exit-code process`](../reference/host/process-exit-code.zh-CN.md) | 查询时不阻塞。状态依后端可能为 `:running`、`:exited` 或 `:unknown`。退出码尚不可用时返回 `nil`。 |
| [`process-wait process`](../reference/host/process-wait.zh-CN.md)、[`process-close process`](../reference/host/process-close.zh-CN.md) | 等待函数在子进程结束后返回原句柄。关闭函数释放本地资源和流，返回 `nil`，不会请求终止子进程。 |

**同步输入输出。** `input` 缺省时子进程读到 EOF，传字符流时提供其剩余内容，传 `t` 时使用 `*standard-input*`。也可传文件名指定输入文件。两个输出通道可分别设置，`:string` 捕获文本，`t` 或字符输出流会在命令结束后重放该通道的文本，相应返回值为 `nil`。捕获和重放使用临时文件，运行时需要可写的临时目录。

在 LispWorks 和 ECL 上传入 `"./worker"` 和子进程目录时，执行的是该目录中的文件。如果要在多个目录中运行同一份程序，可以传入可执行文件的绝对路径。显式提供的 `PWD` 和 `OLDPWD` 会作为环境变量传给子进程。在 Linux 的 LispWorks 8.1.2 中使用 `:directory` 时，需要有读取和进入指定目录的权限，还要能访问 `/proc/self/fd`。[工作目录与启动错误](../reference/host/run-program.zh-CN.md)

**异步管道。** 句柄分别持有标准输出和标准错误的管道。子进程写满任意一条管道就可能阻塞，此时如果父进程只等待结束，双方会一直等待。两路都可能有大量输出时要安排同时读取，或使用 `run-program-sync`。把句柄的使用包在 `unwind-protect` 中，出错时也能清理资源。

| 句柄 API | 含义 |
| --- | --- |
| `host-process`、[`make-host-process &key backend native-handle pid input-stream output-stream error-stream exit-code signal-code`](../reference/host/make-host-process.zh-CN.md) | 结构体类型与构造器。一般使用 `run-program` 返回的已有句柄。 |
| [`host-process-backend process`](../reference/host/host-process-backend.zh-CN.md)、[`host-process-native-handle process`](../reference/host/host-process-native-handle.zh-CN.md) | 返回宿主关键字和由该 Lisp 实现管理的原生句柄。 |
| [`host-process-pid process`](../reference/host/host-process-pid.zh-CN.md) | 如后端提供，返回子进程的系统 PID。 |
| [`host-process-input-stream process`](../reference/host/host-process-input-stream.zh-CN.md)、[`host-process-output-stream process`](../reference/host/host-process-output-stream.zh-CN.md)、[`host-process-error-stream process`](../reference/host/host-process-error-stream.zh-CN.md) | 输入槽的值取决于宿主和启动参数，后两个访问器给出可读取的子进程标准输出与标准错误管道。 |

## 查询或配置当前 Lisp 进程

| 操作 | 用法与返回值 |
| --- | --- |
| [`argv &optional keep-first`](../reference/host/argv.zh-CN.md) | 默认从宿主的参数列表中去掉首项，传真值可保留代表程序的首项。ECL 的列表含解释器选项。以 `--` 分隔脚本实参时，应用实参在此分隔符之后。 |
| [`getenv name`](../reference/host/getenv.zh-CN.md)、[`cwd`](../reference/host/cwd.zh-CN.md)、[`current-process-id`](../reference/host/current-process-id.zh-CN.md) | 分别返回环境变量的字符串值或 `nil`、当前目录名称字符串或 `nil`、当前 Lisp 进程的系统 PID。 |
| [`working-directory-pathname`](../reference/host/working-directory-pathname.zh-CN.md)、[`pathname-directory-list`](../reference/host/pathname-directory-list.zh-CN.md) | 前者解析 Lisp 工作目录，失败时报错；后者取得 pathname 的目录层级，无须访问文件系统。 |
| [`current-user`](../reference/host/current-user.zh-CN.md)、[`home-directory`](../reference/host/home-directory.zh-CN.md) | 分别取得用户名和已存在的主目录名称字符串；无法取得时返回 `nil`。 |
| [`find-executable`](../reference/host/find-executable.zh-CN.md)、[`shell-command-argv`](../reference/host/shell-command-argv.zh-CN.md) | 查找程序时以多个值返回不同的候选路径；需要 shell 解释命令时构造对应的 argv。 |
| [`with-open-utf8-file`](../reference/host/with-open-utf8-file.zh-CN.md) | 打开 UTF-8 字符文件，流的作用域和宏体返回值与 `with-open-file` 一致。 |
| [`unicode-scalar-char`](../reference/host/unicode-scalar-char.zh-CN.md)、[`char-unicode-scalar`](../reference/host/char-unicode-scalar.zh-CN.md) | 在 Unicode 标量和 Lisp 字符之间转换；没有映射时返回 `nil`。 |
| [`standard-input-terminal-p`](../reference/host/standard-input-terminal-p.zh-CN.md)、[`standard-error-terminal-p`](../reference/host/standard-error-terminal-p.zh-CN.md) | 判断文件描述符 0 或 2 是否连接终端。重新绑定 Lisp 的标准流不会影响查询结果。 |
| [`prepare-runtime-io`](../reference/host/prepare-runtime-io.zh-CN.md)（宏）、[`configure-runtime-io`](../reference/host/configure-runtime-io.zh-CN.md) | 在交付的 CLI 入口先调用 prepare，再调用 configure。LispWorks 下前者设置完整字符类型和 UTF-8 控制台策略，后者还将 `*standard-output*`、`*error-output*` 和 `*trace-output*` 绑定到实际文件描述符，trace 写入标准错误。SBCL 和 ECL 下二者均返回 `t`，保留原流。 |
| [`with-character-output-to-string (stream) &body body`](../reference/host/with-character-output-to-string.zh-CN.md) | 宏。将字符写入局部输出流，返回完整字符类型的字符串，可以保留非 ASCII 字符。 |
| [`escape-sh-token value`](../reference/host/escape-sh-token.zh-CN.md) | 返回能作为 POSIX shell 单个参数的引号形式，保留参数中的单引号，`nil` 表示空参数。 |
| [`quit &optional (code 0)`](../reference/host/quit.zh-CN.md) | 用指定退出码结束当前 Lisp 进程。 |
| [`*supported-implementations*`](../reference/host/var-supported-implementations.zh-CN.md)、[`unsupported-host-function`](../reference/host/unsupported-host-function.zh-CN.md) | 变量列出 `"SBCL"`、`"LispWorks"` 和 `"ECL"`。其他实现使用的回退后端定义此错误条件，在调用其未支持的宿主操作时触发。 |
| [`help &optional stream`](../reference/host/help.zh-CN.md)、[`version &optional stream`](../reference/host/version.zh-CN.md) | 返回帮助文本或版本字符串，默认同时写到 `*standard-output*`，传 `nil` 只取字符串。 |

## 在文件锁保护下追加记录

`(append-utf8-line path line)` 创建缺少的父目录，将字符串以 UTF-8 追加到文件，再写入一个换行符，最后返回文件 pathname。字符串路径按操作系统文件名处理。`line` 中已有的换行会保留，需要每次恰好追加一行时，记录本身应去掉行终止符。

`(call-with-exclusive-file-lock lock-path function :timeout 5)` 获取独占文件锁，调用无参函数，返回该函数的全部返回值。所有合作进程须始终使用同一个锁文件，两次调用之间也应保留它。例如，写事件日志的各进程可传入 `(lambda () (han.host:append-utf8-line log-path record))`。函数正常返回或报错均会释放锁。等待时间以秒计，必须非负，默认五秒，传零只尝试一次。超时仍未取得锁则报错。此操作在 macOS 和 Linux 的受支持 Lisp 实现上使用 `flock`。

## 文件系统操作

| 操作 | 用法与返回值 |
| --- | --- |
| [`file-exists-p path`](../reference/host/file-exists-p.zh-CN.md)、[`directory-exists-p path`](../reference/host/directory-exists-p.zh-CN.md) | 返回符合类型的文件或目录 pathname，未探测到时返回 `nil`。 |
| [`directory-files directory`](../reference/host/directory-files.zh-CN.md)、[`subdirectories directory`](../reference/host/subdirectories.zh-CN.md) | 分别返回直接子文件和子目录的 pathname 列表。 |
| [`copy-file source target`](../reference/host/copy-file.zh-CN.md) | 按字节复制，创建父目录，覆盖已有目标，返回传入的 target。 |
| [`delete-directory-tree directory &key (validate t) (if-does-not-exist :ignore)`](../reference/host/delete-directory-tree.zh-CN.md) | 通过 Unix `rm` 递归删除目录，成功返回 `t`。默认校验会拒绝文件系统根目录。目标不存在时，`:ignore` 返回 `nil`，`:error` 报错。 |
| [`temporary-directory`](../reference/host/temporary-directory.zh-CN.md) | 依次从 `TMPDIR`、`TEMP`、`TMP`、`/tmp/` 选取临时目录，返回目录 pathname。 |

实现细节和更多例子见[包定义](../../host/package.lisp)、[共用实现](../../host/common.lisp)、[SBCL 适配](../../host/sbcl.lisp)、[LispWorks 适配](../../host/lispworks.lisp)、[ECL 适配](../../host/ecl.lisp)和[测试](../../host/test.lisp)。
