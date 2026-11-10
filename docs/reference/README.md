# Han Lisp symbol reference

[简体中文](README.zh-CN.md) · [A–Z index](symbols.md) · [User guide](../user/README.md)

Choose a package below, or use the alphabetical index if you only know the symbol name. Each entry identifies the kind of symbol and shows how to use it. Function entries give the arguments and return values. Load `han` before trying an example. Each block runs independently.

| Last line | What it checks |
| --- | --- |
| `;; => "Ada"` | The primary value is the string `"Ada"`. |
| `;; => values (NIL T)` | Returns exactly `NIL` and `T` in that order. Use `values ()` for zero return values. |
| `;; signals han.json:json-error` | The call signals this error type or a subtype. |

For example, [`get-json`](json/get-json.md) distinguishes an explicitly false field from a missing one; [`get-arg`](args/get-arg.md) shows how to recognize a conflicting option. See the [developer workflow](../developer/workflow.md#verify-the-symbol-reference) to run the examples.

[`han.args`](#args) · [`han.host`](#host) · [`han.json`](#json) · [`han.os`](#os) · [`han.path`](#path) · [`han.source`](#source) · [`han.test`](#test)

## Args

[Package guide](../user/args.md)

| Operation | Symbols |
| --- | --- |
| Parsing and lookup | [`parse-args-input`](args/parse-args-input.md) · [`parse-arg-spec`](args/parse-arg-spec.md) · [`parse-args-spec`](args/parse-args-spec.md) · [`bind-args`](args/bind-args.md) · [`get-arg`](args/get-arg.md) · [`arg-key-equal`](args/arg-key-equal.md) |
| Tokens | [`arg-token`](args/arg-token.md) · [`arg-token-p`](args/arg-token-p.md) · [`make-arg-token`](args/make-arg-token.md) · [`arg-token-kind`](args/arg-token-kind.md) · [`arg-token-text`](args/arg-token-text.md) · [`arg-token-value`](args/arg-token-value.md) · [`arg-token-extra`](args/arg-token-extra.md) · [`arg-token-position`](args/arg-token-position.md) |
| Segments | [`arg-segment`](args/arg-segment.md) · [`arg-segment-p`](args/arg-segment-p.md) · [`make-arg-segment`](args/make-arg-segment.md) · [`arg-segment-slot`](args/arg-segment-slot.md) · [`arg-segment-positions`](args/arg-segment-positions.md) |
| Invocation | [`args-input`](args/args-input.md) · [`args-input-p`](args/args-input-p.md) · [`make-args-input`](args/make-args-input.md) · [`args-input-raw-cmd`](args/args-input-raw-cmd.md) · [`args-input-raw-argv`](args/args-input-raw-argv.md) · [`args-input-tokens`](args/args-input-tokens.md) · [`args-input-segments`](args/args-input-segments.md) · [`args-input-diagnostics`](args/args-input-diagnostics.md) |
| Diagnostics | [`arg-diagnostic`](args/arg-diagnostic.md) · [`arg-diagnostic-p`](args/arg-diagnostic-p.md) · [`make-arg-diagnostic`](args/make-arg-diagnostic.md) · [`arg-diagnostic-kind`](args/arg-diagnostic-kind.md) · [`arg-diagnostic-code`](args/arg-diagnostic-code.md) · [`arg-diagnostic-message`](args/arg-diagnostic-message.md) · [`arg-diagnostic-position`](args/arg-diagnostic-position.md) |
| One declaration | [`arg-spec`](args/arg-spec.md) · [`arg-spec-p`](args/arg-spec-p.md) · [`make-arg-spec`](args/make-arg-spec.md) · [`arg-spec-name`](args/arg-spec-name.md) · [`arg-spec-long-entry`](args/arg-spec-long-entry.md) · [`arg-spec-short-entry`](args/arg-spec-short-entry.md) · [`arg-spec-slot-entry`](args/arg-spec-slot-entry.md) · [`arg-spec-arity`](args/arg-spec-arity.md) · [`arg-spec-required`](args/arg-spec-required.md) · [`arg-spec-visibility`](args/arg-spec-visibility.md) · [`arg-spec-default`](args/arg-spec-default.md) |
| Command specification | [`args-spec`](args/args-spec.md) · [`args-spec-p`](args/args-spec-p.md) · [`make-args-spec`](args/make-args-spec.md) · [`args-spec-command`](args/args-spec-command.md) · [`args-spec-args-table`](args/args-spec-args-table.md) |
| Bound argument | [`arg-binding`](args/arg-binding.md) · [`arg-binding-p`](args/arg-binding-p.md) · [`make-arg-binding`](args/make-arg-binding.md) · [`arg-binding-name`](args/arg-binding-name.md) · [`arg-binding-spec`](args/arg-binding-spec.md) · [`arg-binding-value`](args/arg-binding-value.md) · [`arg-binding-status`](args/arg-binding-status.md) |
| Binding result | [`args-result`](args/args-result.md) · [`args-result-p`](args/args-result-p.md) · [`make-args-result`](args/make-args-result.md) · [`args-result-spec`](args/args-result-spec.md) · [`args-result-input`](args/args-result-input.md) · [`args-result-builtin-bindings`](args/args-result-builtin-bindings.md) · [`args-result-bindings`](args/args-result-bindings.md) · [`args-result-diagnostics`](args/args-result-diagnostics.md) |
| Package information | [`help`](args/help.md) · [`version`](args/version.md) |

## Host

[Package guide](../user/host.md)

| Operation | Symbols |
| --- | --- |
| Runtime | [`argv`](host/argv.md) · [`getenv`](host/getenv.md) · [`cwd`](host/cwd.md) · [`current-process-id`](host/current-process-id.md) · [`quit`](host/quit.md) · [`*supported-implementations*`](host/var-supported-implementations.md) · [`unsupported-host-function`](host/unsupported-host-function.md) |
| Host conventions | [`working-directory-pathname`](host/working-directory-pathname.md) · [`current-user`](host/current-user.md) · [`home-directory`](host/home-directory.md) · [`find-executable`](host/find-executable.md) · [`shell-command-argv`](host/shell-command-argv.md) |
| Text and path components | [`unicode-scalar-char`](host/unicode-scalar-char.md) · [`char-unicode-scalar`](host/char-unicode-scalar.md) · [`with-open-utf8-file`](host/with-open-utf8-file.md) · [`pathname-directory-list`](host/pathname-directory-list.md) |
| Terminal and text | [`standard-input-terminal-p`](host/standard-input-terminal-p.md) · [`standard-error-terminal-p`](host/standard-error-terminal-p.md) · [`prepare-runtime-io`](host/prepare-runtime-io.md) · [`configure-runtime-io`](host/configure-runtime-io.md) · [`with-character-output-to-string`](host/with-character-output-to-string.md) · [`escape-sh-token`](host/escape-sh-token.md) |
| Control a child | [`run-program`](host/run-program.md) · [`run-program-sync`](host/run-program-sync.md) · [`process-status`](host/process-status.md) · [`process-exit-code`](host/process-exit-code.md) · [`process-wait`](host/process-wait.md) · [`process-close`](host/process-close.md) |
| Process handles | [`host-process`](host/host-process.md) · [`make-host-process`](host/make-host-process.md) · [`host-process-backend`](host/host-process-backend.md) · [`host-process-native-handle`](host/host-process-native-handle.md) · [`host-process-pid`](host/host-process-pid.md) · [`host-process-input-stream`](host/host-process-input-stream.md) · [`host-process-output-stream`](host/host-process-output-stream.md) · [`host-process-error-stream`](host/host-process-error-stream.md) |
| Files and locks | [`append-utf8-line`](host/append-utf8-line.md) · [`atomic-replace-file`](host/atomic-replace-file.md) · [`call-with-exclusive-file-lock`](host/call-with-exclusive-file-lock.md) · [`temporary-directory`](host/temporary-directory.md) · [`file-exists-p`](host/file-exists-p.md) · [`directory-exists-p`](host/directory-exists-p.md) · [`directory-files`](host/directory-files.md) · [`subdirectories`](host/subdirectories.md) · [`copy-file`](host/copy-file.md) · [`delete-directory-tree`](host/delete-directory-tree.md) |
| Package information | [`help`](host/help.md) · [`version`](host/version.md) |

## Json

[Package guide](../user/json.md)

| Operation | Symbols |
| --- | --- |
| Read and query | [`parse-json`](json/parse-json.md) · [`parse-json-file`](json/parse-json-file.md) · [`read-json-file`](json/read-json-file.md) · [`get-json`](json/get-json.md) · [`json-keys`](json/json-keys.md) · [`json-object-p`](json/json-object-p.md) · [`json-array-p`](json/json-array-p.md) · [`json-null-p`](json/json-null-p.md) · [`json-error`](json/json-error.md) |
| Build and write | [`make-json-object`](json/make-json-object.md) · [`json-object`](json/json-object.md) · [`json-array`](json/json-array.md) · [`set-json`](json/set-json.md) · [`encode-json`](json/encode-json.md) · [`write-json`](json/write-json.md) · [`write-json-file`](json/write-json-file.md) |
| Package information | [`help`](json/help.md) · [`version`](json/version.md) |

## Os

[Package guide](../user/os.md)

| Operation | Symbols |
| --- | --- |
| Streams and text | [`keep-read`](os/keep-read.md) · [`keep-read-line`](os/keep-read-line.md) · [`keep-read-char`](os/keep-read-char.md) · [`load-lines`](os/load-lines.md) · [`load-string`](os/load-string.md) |
| Environment | [`getenv-default`](os/getenv-default.md) · [`require-env`](os/require-env.md) · [`current-user`](os/current-user.md) · [`current-directory`](os/current-directory.md) · [`home-directory`](os/home-directory.md) · [`find-executable`](os/find-executable.md) |
| Commands | [`run-program`](os/run-program.md) · [`run-shell-command`](os/run-shell-command.md) · [`escape-sh-token`](os/escape-sh-token.md) |
| Package information | [`help`](os/help.md) · [`version`](os/version.md) |

## Path

[Package guide](../user/path.md)

| Operation | Symbols |
| --- | --- |
| Path components | [`->pathname`](path/to-pathname.md) · [`->namestring`](path/to-namestring.md) · [`directory-pathname-p`](path/directory-pathname-p.md) · [`directory-pathname`](path/directory-pathname.md) · [`parent-directory-pathname`](path/parent-directory-pathname.md) · [`join-path`](path/join-path.md) · [`absolute-pathname-p`](path/absolute-pathname-p.md) · [`absolute-pathname`](path/absolute-pathname.md) · [`relative-path`](path/relative-path.md) |
| On disk | [`file-exists-p`](path/file-exists-p.md) · [`directory-exists-p`](path/directory-exists-p.md) · [`directory-files`](path/directory-files.md) · [`subdirectories`](path/subdirectories.md) · [`copy-file`](path/copy-file.md) · [`delete-directory-tree`](path/delete-directory-tree.md) · [`temporary-directory`](path/temporary-directory.md) |
| Package information | [`help`](path/help.md) · [`version`](path/version.md) |

## Source

[Package guide](../user/source.md)

| Operation | Symbols |
| --- | --- |
| Cursor | [`char-source`](source/char-source.md) · [`char-source-p`](source/char-source-p.md) · [`make-char-source`](source/make-char-source.md) · [`char-source-string`](source/char-source-string.md) · [`char-source-length`](source/char-source-length.md) · [`source-location`](source/source-location.md) · [`source-eof-p`](source/source-eof-p.md) · [`source-next-char`](source/source-next-char.md) · [`source-advance-n`](source/source-advance-n.md) |
| Matching | [`source-peek-char`](source/source-peek-char.md) · [`source-peek-string`](source/source-peek-string.md) · [`source-match-char-p`](source/source-match-char-p.md) · [`source-match-string-p`](source/source-match-string-p.md) · [`source-consume-char-if`](source/source-consume-char-if.md) · [`source-consume-string-if`](source/source-consume-string-if.md) · [`source-skip-while`](source/source-skip-while.md) · [`source-read-while`](source/source-read-while.md) |
| Marks and spans | [`char-source-mark`](source/char-source-mark.md) · [`char-source-mark-p`](source/char-source-mark-p.md) · [`make-source-mark`](source/make-source-mark.md) · [`source-mark-from-source-p`](source/source-mark-from-source-p.md) · [`source-reset`](source/source-reset.md) · [`char-source-span`](source/char-source-span.md) · [`char-source-span-p`](source/char-source-span-p.md) · [`make-source-span`](source/make-source-span.md) · [`source-span-from-source-p`](source/source-span-from-source-p.md) · [`source-same-origin-p`](source/source-same-origin-p.md) · [`source-slice`](source/source-slice.md) · [`source-slice-by-span`](source/source-slice-by-span.md) |
| Package information | [`help`](source/help.md) · [`version`](source/version.md) |

## Test

[Package guide](../user/test.md)

| Operation | Symbols |
| --- | --- |
| Registry and runner | [`deftest`](test/deftest.md) · [`run-test`](test/run-test.md) · [`run-all-tests`](test/run-all-tests.md) · [`*tests*`](test/var-tests.md) · [`reset-tests`](test/reset-tests.md) |
| Assertions | [`check-true`](test/check-true.md) · [`check-false`](test/check-false.md) · [`check-equal`](test/check-equal.md) · [`check-error`](test/check-error.md) |
| Package information | [`help`](test/help.md) · [`version`](test/version.md) |
