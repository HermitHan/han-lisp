# han.host

[User guide](README.md) · [简体中文](host.zh-CN.md) · [Package symbol index](../reference/README.md#host)

Use `han.host` to control a child process, query the real terminal, or coordinate writers through an OS file lock. It supplies the SBCL and LispWorks adapters. For everyday command execution and path assembly, [han.os](os.md) and [han.path](path.md) offer higher-level operations. All unqualified names below refer to `han.host`.

## Run a child process

For a finished result, pass argv as a nonempty list of strings. Capture stdout and stderr separately and inspect the exit code as the third value.

```lisp
(multiple-value-list
 (han.host:run-program-sync
  '("/bin/sh" "-c" "printf result; printf detail >&2; exit 7")))
;; => ("result" "detail" 7)
```

For a live child, supply an existing executable path and an argument list. Read from the handle and wait for completion. This example's child writes one short message to stdout and nothing to stderr.

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

| Operation | Contract |
| --- | --- |
| [`run-program-sync command &key input (output :string) (error-output :string) (ignore-error-status t)`](../reference/host/run-program-sync.md) | Waits for completion. A list supplies program and arguments directly. A string is a shell command. Each captured channel yields a string, followed by the integer exit status for a normal exit. A nonzero integer status signals an error when `ignore-error-status` is `nil`. |
| [`run-program program &key arguments input directory environment`](../reference/host/run-program.md) | Starts a child and returns a [`host-process`](../reference/host/host-process.md). `program` must name an existing file. To find a program by name, use `han.os:find-executable`. Optional `directory` and `environment` are forwarded to the backend when explicitly supplied. |
| [`process-status process`](../reference/host/process-status.md), [`process-exit-code process`](../reference/host/process-exit-code.md) | Query without blocking. Status can be `:running`, `:exited`, or `:unknown` depending on backend. The exit code is `nil` while unavailable. |
| [`process-wait process`](../reference/host/process-wait.md), [`process-close process`](../reference/host/process-close.md) | Wait returns the original handle after completion. Close releases process resources and streams and returns `nil`. Closing a handle does not request child termination. |

**Synchronous input and output.** With `input` omitted, the child sees EOF. A character stream supplies its remaining contents, and `t` selects `*standard-input*`. A filename can specify the input file. For each output channel, `:string` captures text. `t` or a character output stream replays the captured text after the command finishes and returns `nil` for that channel. Capture and replay use temporary files, so this mode needs a writable temporary directory.

**Live pipes.** The asynchronous handle owns separate stdout and stderr pipes. A child that fills either pipe may block while the parent waits. If output can be large on both channels, drain them concurrently or use `run-program-sync`. An `unwind-protect` around the handle keeps cleanup on the error path as well.

| Handle API | Meaning |
| --- | --- |
| `host-process`, [`make-host-process &key backend native-handle pid input-stream output-stream error-stream exit-code signal-code`](../reference/host/make-host-process.md) | The structure type and its constructor. Normally obtain a populated handle from `run-program`. |
| [`host-process-backend process`](../reference/host/host-process-backend.md), [`host-process-native-handle process`](../reference/host/host-process-native-handle.md) | Backend keyword and implementation-specific status/resource handle. |
| [`host-process-pid process`](../reference/host/host-process-pid.md) | Child process identifier when supplied by the backend. |
| [`host-process-input-stream process`](../reference/host/host-process-input-stream.md), [`host-process-output-stream process`](../reference/host/host-process-output-stream.md), [`host-process-error-stream process`](../reference/host/host-process-error-stream.md) | The input slot depends on backend and launch options. The stdout and stderr accessors return the child pipes to read. |

## Inspect or configure the running Lisp

| Operation | Contract |
| --- | --- |
| [`argv &optional keep-first`](../reference/host/argv.md) | Returns the host argument list with its first element removed by default. A true argument keeps the program element. |
| [`getenv name`](../reference/host/getenv.md), [`cwd`](../reference/host/cwd.md), [`current-process-id`](../reference/host/current-process-id.md) | Read an environment string or `nil`, the working directory namestring or `nil`, and the current Lisp process's OS PID, respectively. |
| [`standard-input-terminal-p`](../reference/host/standard-input-terminal-p.md), [`standard-error-terminal-p`](../reference/host/standard-error-terminal-p.md) | Check whether file descriptor 0 or 2 is a terminal. Rebinding Lisp streams does not change this query. |
| [`prepare-runtime-io`](../reference/host/prepare-runtime-io.md) (macro), [`configure-runtime-io`](../reference/host/configure-runtime-io.md) | At a delivered CLI entry point, call prepare before configure. On LispWorks the former sets full-character and UTF-8 console policy. The latter also replaces `*standard-output*`, `*error-output*` and `*trace-output*` with streams for live descriptors (trace goes to stderr). Both return `t` on SBCL without changing its streams. |
| [`with-character-output-to-string (stream) &body body`](../reference/host/with-character-output-to-string.md) | Macro. Evaluates the body with a character output stream and returns the generated full-character string, including non-ASCII characters. |
| [`escape-sh-token value`](../reference/host/escape-sh-token.md) | Returns a token quoted for a POSIX shell. Embedded apostrophes survive as data, and `nil` means an empty token. |
| [`quit &optional (code 0)`](../reference/host/quit.md) | Exits the running Lisp with the supplied status. |
| [`*supported-implementations*`](../reference/host/var-supported-implementations.md), [`unsupported-host-function`](../reference/host/unsupported-host-function.md) | The variable lists `"SBCL"` and `"LispWorks"`. The fallback backend for other implementations defines this error condition and signals it for its unsupported primitives. |
| [`help &optional stream`](../reference/host/help.md), [`version &optional stream`](../reference/host/version.md) | Return the help text or version string and print to the supplied stream (default `*standard-output*`). Use `nil` to obtain just the string. |

## Append a record under a lock

`(append-utf8-line path line)` creates missing parent directories, appends the string as UTF-8 plus one newline, and returns the prepared file pathname. A string path is treated as an OS filename. An existing terminal newline in `line` is preserved, so supply a record without its terminator for one line per call.

`(call-with-exclusive-file-lock lock-path function :timeout 5)` calls a zero-argument function while holding an exclusive OS lock and returns all the function's values. All cooperating writers must keep using the same lock file, including between calls. For an event log, each writer passes a callback such as `(lambda () (han.host:append-utf8-line log-path record))`. The lock is released on normal return or an error. The nonnegative timeout is in seconds, defaults to five, and zero attempts the lock once. Contention beyond the timeout signals an error. This operation uses `flock` on macOS and Linux with the supported Lisp implementations.

## Filesystem operations

| Operation | Contract |
| --- | --- |
| [`file-exists-p path`](../reference/host/file-exists-p.md), [`directory-exists-p path`](../reference/host/directory-exists-p.md) | Return the matching file or directory pathname, or `nil`. |
| [`directory-files directory`](../reference/host/directory-files.md), [`subdirectories directory`](../reference/host/subdirectories.md) | Return lists of immediate children of the requested kind. |
| [`copy-file source target`](../reference/host/copy-file.md) | Copies bytes, creates parent directories, replaces an existing target and returns the target argument. |
| [`delete-directory-tree directory &key (validate t) (if-does-not-exist :ignore)`](../reference/host/delete-directory-tree.md) | Recursively removes the directory with Unix `rm` and returns `t`. Validation rejects the root directory. An absent target returns `nil` with `:ignore` or signals an error with `:error`. |
| [`temporary-directory`](../reference/host/temporary-directory.md) | Returns the directory pathname from `TMPDIR`, `TEMP`, `TMP`, or the default `/tmp/`. |

See the [exports](../../host/package.lisp), [shared implementation](../../host/common.lisp), [SBCL adapter](../../host/sbcl.lisp), [LispWorks adapter](../../host/lispworks.lisp), and [tests](../../host/test.lisp).
