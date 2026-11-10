# Han Lisp 公开符号参考

[English](README.md) · [按符号名查找](symbols.zh-CN.md) · [用户手册](../user/README.zh-CN.md)

知道包名时可以从下表进入，只记得符号名时可以查字母索引。每个条目都标明符号种类，并用示例展示它的用法。函数条目列出参数和返回值。先加载 `han`，再任选一个示例独立运行。

| 末行标注 | 核对内容 |
| --- | --- |
| `;; => "Ada"` | 主返回值为字符串 `"Ada"`。 |
| `;; => values (NIL T)` | 依次返回 `NIL` 和 `T`；`values ()` 表示不返回任何值。 |
| `;; signals han.json:json-error` | 调用触发此类型的错误或其子类型。 |

例如，[`get-json`](json/get-json.zh-CN.md) 演示如何区分值为假的字段与不存在的字段；[`get-arg`](args/get-arg.zh-CN.md) 演示如何从返回值识别选项冲突。要执行整本参考手册的示例，见[开发者手册](../developer/workflow.zh-CN.md#验证符号参考)。

[`han.args`](#args) · [`han.host`](#host) · [`han.json`](#json) · [`han.os`](#os) · [`han.path`](#path) · [`han.source`](#source) · [`han.test`](#test)

## Args

[包用法](../user/args.zh-CN.md)

| 用途 | 符号 |
| --- | --- |
| 解析与查询 | [`parse-args-input`](args/parse-args-input.zh-CN.md) · [`parse-arg-spec`](args/parse-arg-spec.zh-CN.md) · [`parse-args-spec`](args/parse-args-spec.zh-CN.md) · [`bind-args`](args/bind-args.zh-CN.md) · [`get-arg`](args/get-arg.zh-CN.md) · [`arg-key-equal`](args/arg-key-equal.zh-CN.md) |
| 词元 | [`arg-token`](args/arg-token.zh-CN.md) · [`arg-token-p`](args/arg-token-p.zh-CN.md) · [`make-arg-token`](args/make-arg-token.zh-CN.md) · [`arg-token-kind`](args/arg-token-kind.zh-CN.md) · [`arg-token-text`](args/arg-token-text.zh-CN.md) · [`arg-token-value`](args/arg-token-value.zh-CN.md) · [`arg-token-extra`](args/arg-token-extra.zh-CN.md) · [`arg-token-position`](args/arg-token-position.zh-CN.md) |
| 参数片段 | [`arg-segment`](args/arg-segment.zh-CN.md) · [`arg-segment-p`](args/arg-segment-p.zh-CN.md) · [`make-arg-segment`](args/make-arg-segment.zh-CN.md) · [`arg-segment-slot`](args/arg-segment-slot.zh-CN.md) · [`arg-segment-positions`](args/arg-segment-positions.zh-CN.md) |
| 命令行输入 | [`args-input`](args/args-input.zh-CN.md) · [`args-input-p`](args/args-input-p.zh-CN.md) · [`make-args-input`](args/make-args-input.zh-CN.md) · [`args-input-raw-cmd`](args/args-input-raw-cmd.zh-CN.md) · [`args-input-raw-argv`](args/args-input-raw-argv.zh-CN.md) · [`args-input-tokens`](args/args-input-tokens.zh-CN.md) · [`args-input-segments`](args/args-input-segments.zh-CN.md) · [`args-input-diagnostics`](args/args-input-diagnostics.zh-CN.md) |
| 诊断 | [`arg-diagnostic`](args/arg-diagnostic.zh-CN.md) · [`arg-diagnostic-p`](args/arg-diagnostic-p.zh-CN.md) · [`make-arg-diagnostic`](args/make-arg-diagnostic.zh-CN.md) · [`arg-diagnostic-kind`](args/arg-diagnostic-kind.zh-CN.md) · [`arg-diagnostic-code`](args/arg-diagnostic-code.zh-CN.md) · [`arg-diagnostic-message`](args/arg-diagnostic-message.zh-CN.md) · [`arg-diagnostic-position`](args/arg-diagnostic-position.zh-CN.md) |
| 单项规格 | [`arg-spec`](args/arg-spec.zh-CN.md) · [`arg-spec-p`](args/arg-spec-p.zh-CN.md) · [`make-arg-spec`](args/make-arg-spec.zh-CN.md) · [`arg-spec-name`](args/arg-spec-name.zh-CN.md) · [`arg-spec-long-entry`](args/arg-spec-long-entry.zh-CN.md) · [`arg-spec-short-entry`](args/arg-spec-short-entry.zh-CN.md) · [`arg-spec-slot-entry`](args/arg-spec-slot-entry.zh-CN.md) · [`arg-spec-arity`](args/arg-spec-arity.zh-CN.md) · [`arg-spec-required`](args/arg-spec-required.zh-CN.md) · [`arg-spec-visibility`](args/arg-spec-visibility.zh-CN.md) · [`arg-spec-default`](args/arg-spec-default.zh-CN.md) |
| 命令规格 | [`args-spec`](args/args-spec.zh-CN.md) · [`args-spec-p`](args/args-spec-p.zh-CN.md) · [`make-args-spec`](args/make-args-spec.zh-CN.md) · [`args-spec-command`](args/args-spec-command.zh-CN.md) · [`args-spec-args-table`](args/args-spec-args-table.zh-CN.md) |
| 单个绑定 | [`arg-binding`](args/arg-binding.zh-CN.md) · [`arg-binding-p`](args/arg-binding-p.zh-CN.md) · [`make-arg-binding`](args/make-arg-binding.zh-CN.md) · [`arg-binding-name`](args/arg-binding-name.zh-CN.md) · [`arg-binding-spec`](args/arg-binding-spec.zh-CN.md) · [`arg-binding-value`](args/arg-binding-value.zh-CN.md) · [`arg-binding-status`](args/arg-binding-status.zh-CN.md) |
| 绑定结果 | [`args-result`](args/args-result.zh-CN.md) · [`args-result-p`](args/args-result-p.zh-CN.md) · [`make-args-result`](args/make-args-result.zh-CN.md) · [`args-result-spec`](args/args-result-spec.zh-CN.md) · [`args-result-input`](args/args-result-input.zh-CN.md) · [`args-result-builtin-bindings`](args/args-result-builtin-bindings.zh-CN.md) · [`args-result-bindings`](args/args-result-bindings.zh-CN.md) · [`args-result-diagnostics`](args/args-result-diagnostics.zh-CN.md) |
| 包信息 | [`help`](args/help.zh-CN.md) · [`version`](args/version.zh-CN.md) |

## Host

[包用法](../user/host.zh-CN.md)

| 用途 | 符号 |
| --- | --- |
| 宿主环境 | [`argv`](host/argv.zh-CN.md) · [`getenv`](host/getenv.zh-CN.md) · [`cwd`](host/cwd.zh-CN.md) · [`current-process-id`](host/current-process-id.zh-CN.md) · [`quit`](host/quit.zh-CN.md) · [`*supported-implementations*`](host/var-supported-implementations.zh-CN.md) · [`unsupported-host-function`](host/unsupported-host-function.zh-CN.md) |
| 宿主约定 | [`working-directory-pathname`](host/working-directory-pathname.zh-CN.md) · [`current-user`](host/current-user.zh-CN.md) · [`home-directory`](host/home-directory.zh-CN.md) · [`find-executable`](host/find-executable.zh-CN.md) · [`shell-command-argv`](host/shell-command-argv.zh-CN.md) |
| 文本与路径组件 | [`unicode-scalar-char`](host/unicode-scalar-char.zh-CN.md) · [`char-unicode-scalar`](host/char-unicode-scalar.zh-CN.md) · [`with-open-utf8-file`](host/with-open-utf8-file.zh-CN.md) · [`pathname-directory-list`](host/pathname-directory-list.zh-CN.md) |
| 终端与字符 | [`standard-input-terminal-p`](host/standard-input-terminal-p.zh-CN.md) · [`standard-error-terminal-p`](host/standard-error-terminal-p.zh-CN.md) · [`prepare-runtime-io`](host/prepare-runtime-io.zh-CN.md) · [`configure-runtime-io`](host/configure-runtime-io.zh-CN.md) · [`with-character-output-to-string`](host/with-character-output-to-string.zh-CN.md) · [`escape-sh-token`](host/escape-sh-token.zh-CN.md) |
| 进程控制 | [`run-program`](host/run-program.zh-CN.md) · [`run-program-sync`](host/run-program-sync.zh-CN.md) · [`process-status`](host/process-status.zh-CN.md) · [`process-exit-code`](host/process-exit-code.zh-CN.md) · [`process-wait`](host/process-wait.zh-CN.md) · [`process-close`](host/process-close.zh-CN.md) |
| 进程句柄 | [`host-process`](host/host-process.zh-CN.md) · [`make-host-process`](host/make-host-process.zh-CN.md) · [`host-process-backend`](host/host-process-backend.zh-CN.md) · [`host-process-native-handle`](host/host-process-native-handle.zh-CN.md) · [`host-process-pid`](host/host-process-pid.zh-CN.md) · [`host-process-input-stream`](host/host-process-input-stream.zh-CN.md) · [`host-process-output-stream`](host/host-process-output-stream.zh-CN.md) · [`host-process-error-stream`](host/host-process-error-stream.zh-CN.md) |
| 文件与锁 | [`append-utf8-line`](host/append-utf8-line.zh-CN.md) · [`atomic-replace-file`](host/atomic-replace-file.zh-CN.md) · [`call-with-exclusive-file-lock`](host/call-with-exclusive-file-lock.zh-CN.md) · [`temporary-directory`](host/temporary-directory.zh-CN.md) · [`file-exists-p`](host/file-exists-p.zh-CN.md) · [`directory-exists-p`](host/directory-exists-p.zh-CN.md) · [`directory-files`](host/directory-files.zh-CN.md) · [`subdirectories`](host/subdirectories.zh-CN.md) · [`copy-file`](host/copy-file.zh-CN.md) · [`delete-directory-tree`](host/delete-directory-tree.zh-CN.md) |
| 包信息 | [`help`](host/help.zh-CN.md) · [`version`](host/version.zh-CN.md) |

## Json

[包用法](../user/json.zh-CN.md)

| 用途 | 符号 |
| --- | --- |
| 读取与查询 | [`parse-json`](json/parse-json.zh-CN.md) · [`parse-json-file`](json/parse-json-file.zh-CN.md) · [`read-json-file`](json/read-json-file.zh-CN.md) · [`get-json`](json/get-json.zh-CN.md) · [`json-keys`](json/json-keys.zh-CN.md) · [`json-object-p`](json/json-object-p.zh-CN.md) · [`json-array-p`](json/json-array-p.zh-CN.md) · [`json-null-p`](json/json-null-p.zh-CN.md) · [`json-error`](json/json-error.zh-CN.md) |
| 构造与写出 | [`make-json-object`](json/make-json-object.zh-CN.md) · [`json-object`](json/json-object.zh-CN.md) · [`json-array`](json/json-array.zh-CN.md) · [`set-json`](json/set-json.zh-CN.md) · [`encode-json`](json/encode-json.zh-CN.md) · [`write-json`](json/write-json.zh-CN.md) · [`write-json-file`](json/write-json-file.zh-CN.md) |
| 包信息 | [`help`](json/help.zh-CN.md) · [`version`](json/version.zh-CN.md) |

## Os

[包用法](../user/os.zh-CN.md)

| 用途 | 符号 |
| --- | --- |
| 流与文本 | [`keep-read`](os/keep-read.zh-CN.md) · [`keep-read-line`](os/keep-read-line.zh-CN.md) · [`keep-read-char`](os/keep-read-char.zh-CN.md) · [`load-lines`](os/load-lines.zh-CN.md) · [`load-string`](os/load-string.zh-CN.md) |
| 环境 | [`getenv-default`](os/getenv-default.zh-CN.md) · [`require-env`](os/require-env.zh-CN.md) · [`current-user`](os/current-user.zh-CN.md) · [`current-directory`](os/current-directory.zh-CN.md) · [`home-directory`](os/home-directory.zh-CN.md) · [`find-executable`](os/find-executable.zh-CN.md) |
| 执行命令 | [`run-program`](os/run-program.zh-CN.md) · [`run-shell-command`](os/run-shell-command.zh-CN.md) · [`escape-sh-token`](os/escape-sh-token.zh-CN.md) |
| 包信息 | [`help`](os/help.zh-CN.md) · [`version`](os/version.zh-CN.md) |

## Path

[包用法](../user/path.zh-CN.md)

| 用途 | 符号 |
| --- | --- |
| 路径分量 | [`->pathname`](path/to-pathname.zh-CN.md) · [`->namestring`](path/to-namestring.zh-CN.md) · [`directory-pathname-p`](path/directory-pathname-p.zh-CN.md) · [`directory-pathname`](path/directory-pathname.zh-CN.md) · [`parent-directory-pathname`](path/parent-directory-pathname.zh-CN.md) · [`join-path`](path/join-path.zh-CN.md) · [`absolute-pathname-p`](path/absolute-pathname-p.zh-CN.md) · [`absolute-pathname`](path/absolute-pathname.zh-CN.md) · [`relative-path`](path/relative-path.zh-CN.md) |
| 文件系统 | [`file-exists-p`](path/file-exists-p.zh-CN.md) · [`directory-exists-p`](path/directory-exists-p.zh-CN.md) · [`directory-files`](path/directory-files.zh-CN.md) · [`subdirectories`](path/subdirectories.zh-CN.md) · [`copy-file`](path/copy-file.zh-CN.md) · [`delete-directory-tree`](path/delete-directory-tree.zh-CN.md) · [`temporary-directory`](path/temporary-directory.zh-CN.md) |
| 包信息 | [`help`](path/help.zh-CN.md) · [`version`](path/version.zh-CN.md) |

## Source

[包用法](../user/source.zh-CN.md)

| 用途 | 符号 |
| --- | --- |
| 游标 | [`char-source`](source/char-source.zh-CN.md) · [`char-source-p`](source/char-source-p.zh-CN.md) · [`make-char-source`](source/make-char-source.zh-CN.md) · [`char-source-string`](source/char-source-string.zh-CN.md) · [`char-source-length`](source/char-source-length.zh-CN.md) · [`source-location`](source/source-location.zh-CN.md) · [`source-eof-p`](source/source-eof-p.zh-CN.md) · [`source-next-char`](source/source-next-char.zh-CN.md) · [`source-advance-n`](source/source-advance-n.zh-CN.md) |
| 识别与读取 | [`source-peek-char`](source/source-peek-char.zh-CN.md) · [`source-peek-string`](source/source-peek-string.zh-CN.md) · [`source-match-char-p`](source/source-match-char-p.zh-CN.md) · [`source-match-string-p`](source/source-match-string-p.zh-CN.md) · [`source-consume-char-if`](source/source-consume-char-if.zh-CN.md) · [`source-consume-string-if`](source/source-consume-string-if.zh-CN.md) · [`source-skip-while`](source/source-skip-while.zh-CN.md) · [`source-read-while`](source/source-read-while.zh-CN.md) |
| 标记与区间 | [`char-source-mark`](source/char-source-mark.zh-CN.md) · [`char-source-mark-p`](source/char-source-mark-p.zh-CN.md) · [`make-source-mark`](source/make-source-mark.zh-CN.md) · [`source-mark-from-source-p`](source/source-mark-from-source-p.zh-CN.md) · [`source-reset`](source/source-reset.zh-CN.md) · [`char-source-span`](source/char-source-span.zh-CN.md) · [`char-source-span-p`](source/char-source-span-p.zh-CN.md) · [`make-source-span`](source/make-source-span.zh-CN.md) · [`source-span-from-source-p`](source/source-span-from-source-p.zh-CN.md) · [`source-same-origin-p`](source/source-same-origin-p.zh-CN.md) · [`source-slice`](source/source-slice.zh-CN.md) · [`source-slice-by-span`](source/source-slice-by-span.zh-CN.md) |
| 包信息 | [`help`](source/help.zh-CN.md) · [`version`](source/version.zh-CN.md) |

## Test

[包用法](../user/test.zh-CN.md)

| 用途 | 符号 |
| --- | --- |
| 登记与运行 | [`deftest`](test/deftest.zh-CN.md) · [`run-test`](test/run-test.zh-CN.md) · [`run-all-tests`](test/run-all-tests.zh-CN.md) · [`*tests*`](test/var-tests.zh-CN.md) · [`reset-tests`](test/reset-tests.zh-CN.md) |
| 断言 | [`check-true`](test/check-true.zh-CN.md) · [`check-false`](test/check-false.zh-CN.md) · [`check-equal`](test/check-equal.zh-CN.md) · [`check-error`](test/check-error.zh-CN.md) |
| 包信息 | [`help`](test/help.zh-CN.md) · [`version`](test/version.zh-CN.md) |
