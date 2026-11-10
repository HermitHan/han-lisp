# han.os

[用户手册](README.zh-CN.md) · [English](os.md) · [本包符号参考](../reference/README.zh-CN.md#os)

用 `han.os` 从流里读数据、查询环境，或执行命令并收集输出。表中函数均属于 `han.os`。

## 读几行，再从当前位置继续

传入已打开的流，可以分次消费其内容。

```lisp
(with-input-from-string (input (format nil "alpha~%beta~%gamma~%"))
  (list (han.os:keep-read-line input 2)
        (han.os:load-lines input)))
;; => (("alpha" "beta") ("gamma"))
```

| 操作 | 输入与返回值 |
| --- | --- |
| [`keep-read &optional stream limit`](../reference/os/keep-read.zh-CN.md)、[`keep-read-char &optional stream limit`](../reference/os/keep-read-char.zh-CN.md)、[`keep-read-line &optional stream limit`](../reference/os/keep-read-line.zh-CN.md) | 分别读取 Lisp 对象、字符和行，按输入顺序返回列表，默认读 `*standard-input*`。`limit` 为 `nil` 时读到 EOF，整数限制读取数量。也可传入函数，每次读取前它会收到**逆序**的已读列表，第一次收到空列表，返回真就继续读。 |
| [`load-lines input`](../reference/os/load-lines.zh-CN.md) | 接受字符流，或以 UTF-8 打开给定文件名（字符串或 pathname）。返回剩余各行组成的字符串列表，去掉行终止符。文件缺失时报错，传入的流仍由调用方管理。 |
| [`load-string input`](../reference/os/load-string.zh-CN.md) | 接受相同输入，把读到的各行用换行符连接。换行符只放在相邻项之间，原文末尾的一个行终止符会被省略。 |

`keep-read` 调用 Common Lisp 的读取器，适合按指定读取器设置解析 Lisp 数据。普通文本可直接用 `keep-read-line`。

## 向外部程序传参

用字符串列表传入程序名和各个参数，参数中的空格会保留。如果要把一段文字送入标准输入，传入字符流即可。

```lisp
(with-input-from-string (input "two words")
  (multiple-value-list
   (han.os:run-program '("/bin/cat") :input input)))
;; => ("two words" "" 0)
```

| 操作 | 输入与返回值 |
| --- | --- |
| [`run-program command &key input (output :string) (error-output :string) (ignore-error-status t)`](../reference/os/run-program.zh-CN.md) | 同步执行，按**三个值**返回标准输出、标准错误和退出码。非空字符串列表表示 argv，命令字符串按 shell 语法解释。`input` 默认提供 EOF，传 `t` 时使用标准输入。两个输出通道默认分别捕获为字符串。设为 `t` 或输出流时在命令结束后重放，对应返回值为 `nil`。设 `:ignore-error-status nil` 时，非零整数退出码会触发错误。 |
| [`escape-sh-token value`](../reference/os/escape-sh-token.zh-CN.md) | 把单个参数写成带引号的 POSIX shell 词。`nil` 会转为空字符串的引号形式。拼接 shell 文本时可用它嵌入一个参数。 |
| [`run-shell-command command &key (wait t) (lines t) shell`](../reference/os/run-shell-command.zh-CN.md) | 通过 shell 的 `-c` 执行命令文本。可用 `shell` 指定可执行文件路径，默认先查找 `bash` 再查找 `sh`。等待模式下返回标准输出行列表、标准错误行列表和退出码。传 `:lines nil` 可得到字符串，保留输出结尾的换行符。 |

要让 argv 调用在各个后端都能启动，请传入可执行文件的完整路径。只有程序名时，可用 `han.os:find-executable` 查找，确认结果非 `nil` 后再启动。curl 等子程序报告连接失败时，退出码和标准错误来自该程序。如果子进程被 Unix 信号终止，SBCL 返回信号编号，LispWorks、ECL 和 CCL 返回 128 加该编号。[查找可执行文件](../reference/os/find-executable.zh-CN.md) · [子进程的返回值](../reference/host/run-program-sync.zh-CN.md)

ECL 和 CCL 的同步调用若给输入或任一输出传 `:stream`，会在启动前发出 `simple-error`。需要管道时，请用 [han.host:run-program](../reference/host/run-program.zh-CN.md) 启动子进程。

通过 `:input t` 从终端提供输入时，LispWorks、ECL 和 CCL 会等到 EOF 才启动子进程。CCL 按 UTF-8 读取捕获的标准输出和标准错误。SBCL、LispWorks 和 ECL 沿用宿主默认文本编码。[同步进程参考](../reference/host/run-program-sync.zh-CN.md)

有重定向时可以交给 shell。下面的参数包含单引号和美元符号，二者都会按原样传给 `printf`。即使退出码非零，调用方也能取到错误输出。

```lisp
(multiple-value-list
 (han.os:run-shell-command
  (format nil "printf '%s\\n' ~A; printf 'note\\n' >&2; exit 3"
          (han.os:escape-sh-token "Kai's $HOME"))
  :shell "/bin/sh"))
;; => (("Kai's $HOME") ("note") 3)
```

给 `run-shell-command` 传 `:wait nil` 时，会得到**四个值**，依次是标准输出流、标准错误流、退出码占位 `nil` 和 `han.host:host-process` 句柄。此时 `lines` 不影响结果。调用方负责读取管道，以 `han.host:process-wait` 等待结束，再用 `han.host:process-exit-code` 取退出码，用 `han.host:process-close` 释放资源。若两个输出通道都有可能产生大量数据，应安排同时读取两个通道，或使用同步捕获。见[进程控制](host.zh-CN.md)。

## 查找配置和程序

| 操作 | 返回值 |
| --- | --- |
| [`getenv-default name default`](../reference/os/getenv-default.zh-CN.md)、[`require-env name`](../reference/os/require-env.zh-CN.md) | 读取环境变量的字符串值。未设置时，前者返回传入的默认值，后者报错。变量已设为空字符串时也算存在。ECL 会保留长 UTF-8 值的完整内容。 |
| [`current-user &optional (default "World")`](../reference/os/current-user.zh-CN.md) | 依次尝试 `USER`、`LOGNAME` 和指定的默认值。 |
| [`current-directory`](../reference/os/current-directory.zh-CN.md)、[`home-directory`](../reference/os/home-directory.zh-CN.md) | 返回目录名称字符串，无法取得时为 `nil`。主目录优先选用确实存在的 `HOME`，然后尝试 Lisp 的用户主目录。 |
| [`find-executable program`](../reference/os/find-executable.zh-CN.md) | 看起来像路径的字符串会先按原路径尝试。对于单个程序名，依次搜索 `PATH` 和内置的 Unix 目录。主返回值是第一个匹配的文件路径，未找到时为 `nil`，其余匹配可能作为后续值返回。它只检查文件是否存在。 |
| [`help &optional stream`](../reference/os/help.zh-CN.md)、[`version &optional stream`](../reference/os/version.zh-CN.md) | 返回帮助文本或版本字符串，默认同时写到 `*standard-output*`，传 `nil` 只取字符串。 |

导出列表和更多例子见[包定义](../../os/package.lisp)与[测试](../../os/test.lisp)。
