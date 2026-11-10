# han.host

[User guide](README.md) · [简体中文](host.zh-CN.md) · [Package symbol index](../reference/README.md#host)

Use `han.host` to control a child process, query the real terminal, or coordinate writers through an OS file lock. It supplies adapters for SBCL, LispWorks, Clozure CL (CCL) 1.14 and Unicode-enabled ECL. For everyday command execution and path assembly, [han.os](os.md) and [han.path](path.md) offer higher-level operations. All unqualified names below refer to `han.host`.

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
| [`run-program program &key arguments input directory environment`](../reference/host/run-program.md) | Starts a child and returns a [`host-process`](../reference/host/host-process.md). `program` must name an existing file. To find a program by name, use `han.os:find-executable`. Set `directory` to run in an existing directory while the parent keeps its own. Omitting `environment` inherits the parent’s environment. The linked reference describes each backend’s explicit environment format. |
| [`process-status process`](../reference/host/process-status.md), [`process-exit-code process`](../reference/host/process-exit-code.md) | Query without blocking. Status can be `:running`, `:exited`, or `:unknown` depending on backend. The exit code is `nil` while unavailable. |
| [`process-wait process`](../reference/host/process-wait.md), [`process-close process`](../reference/host/process-close.md) | Wait returns the original handle after completion. Close releases process resources and streams and returns `nil`. Closing a handle does not request child termination. |

**Synchronous input and output.** With `input` omitted, the child sees EOF. A character stream supplies its remaining contents, and `t` selects `*standard-input*`. A filename can specify the input file. For each output channel, `:string` captures text. `t` or a character output stream replays the captured text after the command finishes and returns `nil` for that channel. Capture and replay use temporary files, so this mode needs a writable temporary directory.

On LispWorks, ECL and CCL, `"./worker"` is resolved in the supplied child directory. Use an absolute executable path if the same program should run in several directories. Explicit values for `PWD` and `OLDPWD` are passed to the child as environment data. When you supply `:directory` on Linux with LispWorks 8.1.2, the directory must be readable and searchable, and `/proc/self/fd` must be accessible. [Working directory and launch errors](../reference/host/run-program.md)

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
| [`argv &optional keep-first`](../reference/host/argv.md) | Returns the host argument list with its first element removed by default. A true argument keeps the program element. ECL decodes each complete OS argument as UTF-8, including empty and long arguments. CCL includes switches left after kernel option processing. For a script launched with `--`, the application arguments follow that separator. |
| [`getenv name`](../reference/host/getenv.md), [`cwd`](../reference/host/cwd.md), [`current-process-id`](../reference/host/current-process-id.md) | Read an environment string or `nil`, the working directory namestring or `nil`, and the current Lisp process's OS PID, respectively. |
| [`working-directory-pathname`](../reference/host/working-directory-pathname.md), [`pathname-directory-list`](../reference/host/pathname-directory-list.md) | Resolve the Lisp working directory, signaling on failure; inspect a pathname’s directory hierarchy without probing the filesystem. |
| [`current-user`](../reference/host/current-user.md), [`home-directory`](../reference/host/home-directory.md) | Return the user name or an existing home directory namestring, respectively; unavailable values are `nil`. |
| [`find-executable`](../reference/host/find-executable.md), [`shell-command-argv`](../reference/host/shell-command-argv.md) | Find distinct candidate paths as multiple values, or build the argv for a command intended for a shell. |
| [`with-open-utf8-file`](../reference/host/with-open-utf8-file.md) | Open a UTF-8 character file with the usual `with-open-file` lifetime and return values. |
| [`unicode-scalar-char`](../reference/host/unicode-scalar-char.md), [`char-unicode-scalar`](../reference/host/char-unicode-scalar.md) | Convert between a Unicode scalar and a Lisp character. A missing mapping returns `nil`. |
| [`standard-input-terminal-p`](../reference/host/standard-input-terminal-p.md), [`standard-error-terminal-p`](../reference/host/standard-error-terminal-p.md) | Check whether file descriptor 0 or 2 is a terminal. Rebinding Lisp streams does not change this query. |
| [`prepare-runtime-io`](../reference/host/prepare-runtime-io.md) (macro), [`configure-runtime-io`](../reference/host/configure-runtime-io.md) | At a delivered CLI entry point, call prepare before configure. On LispWorks the former sets full-character and UTF-8 console policy. The latter also replaces `*standard-output*`, `*error-output*` and `*trace-output*` with streams for live descriptors (trace goes to stderr). On SBCL, ECL and CCL both return `t` and preserve the existing streams. |
| [`with-character-output-to-string (stream) &body body`](../reference/host/with-character-output-to-string.md) | Macro. Evaluates the body with a character output stream and returns the generated full-character string, including non-ASCII characters. |
| [`escape-sh-token value`](../reference/host/escape-sh-token.md) | Returns a token quoted for a POSIX shell. Embedded apostrophes survive as data, and `nil` means an empty token. |
| [`quit &optional (code 0)`](../reference/host/quit.md) | Flushes standard output and standard error, then exits. A stdout flush error changes success (0) to 1 and preserves an explicitly requested nonzero code. The final stderr flush is best effort, including for optional progress messages. |
| [`*supported-implementations*`](../reference/host/var-supported-implementations.md), [`unsupported-host-function`](../reference/host/unsupported-host-function.md) | The variable lists `"SBCL"`, `"LispWorks"`, `"ECL"` and `"CCL"`. The fallback backend for other implementations defines this error condition and signals it for its unsupported primitives. |
| [`help &optional stream`](../reference/host/help.md), [`version &optional stream`](../reference/host/version.md) | Return the help text or version string and print to the supplied stream (default `*standard-output*`). Use `nil` to obtain just the string. |

## Append a record under a lock

`(append-utf8-line path line)` creates missing parent directories, appends the string as UTF-8 plus one newline, and returns the prepared file pathname. A string path is treated as an OS filename. An existing terminal newline in `line` is preserved, so supply a record without its terminator for one line per call. [Append a UTF-8 line](../reference/host/append-utf8-line.md)

`(call-with-exclusive-file-lock lock-path function :timeout 5)` calls a zero-argument function while holding an exclusive OS lock and returns all the function's values. All cooperating writers must keep using the same lock file, including between calls. For an event log, each writer passes a callback such as `(lambda () (han.host:append-utf8-line log-path record))`. The lock is released on normal return or an error. The nonnegative timeout is in seconds, defaults to five, and zero attempts the lock once. Contention beyond the timeout signals an error. This operation uses `flock` on macOS and Linux with the supported Lisp implementations. [Exclusive file lock](../reference/host/call-with-exclusive-file-lock.md)

## Filesystem operations

To publish a file, finish writing and close a staged regular file on the target filesystem. Pass its literal filename and the exact target filename as strings to `(han.host:atomic-replace-file source target)`. For example, a file named `staged.tmp` can replace a file named `launcher`. The target keeps the staged file’s permission bits, so set its executable mode before the call. A reader with the old file open can finish reading it. Opening the target after the switch gives the complete new file.

The application chooses which files may be replaced and must keep other writers from changing either directory entry or its parent during the call. Both parent directories must already exist. A cross-filesystem move or a directory target signals `file-error` and leaves both paths intact. The symbol reference includes runnable examples for creating a target, replacing it while a reader is active, and handling an error. [Atomic file replacement](../reference/host/atomic-replace-file.md)

| Operation | Contract |
| --- | --- |
| [`file-exists-p path`](../reference/host/file-exists-p.md), [`directory-exists-p path`](../reference/host/directory-exists-p.md) | Return the matching file or directory pathname, or `nil`. |
| [`directory-files directory`](../reference/host/directory-files.md), [`subdirectories directory`](../reference/host/subdirectories.md) | Return lists of immediate children of the requested kind. |
| [`copy-file source target`](../reference/host/copy-file.md) | Copies bytes, creates parent directories, replaces an existing target and returns the target argument. |
| [`atomic-replace-file source target`](../reference/host/atomic-replace-file.md) | Atomically moves a prepared regular file to the exact target name, creating or replacing a regular file there. Returns `t`. |
| [`delete-directory-tree directory &key (validate t) (if-does-not-exist :ignore)`](../reference/host/delete-directory-tree.md) | Recursively removes the directory with Unix `rm` and returns `t`. Validation rejects the root directory. An absent target returns `nil` with `:ignore` or signals an error with `:error`. |
| [`temporary-directory`](../reference/host/temporary-directory.md) | Returns the directory pathname from `TMPDIR`, `TEMP`, `TMP`, or the default `/tmp/`. |

See the [exports](../../host/package.lisp), [shared implementation](../../host/common.lisp), [SBCL adapter](../../host/sbcl.lisp), [LispWorks adapter](../../host/lispworks.lisp), [ECL adapter](../../host/ecl.lisp), [CCL adapter](../../host/ccl.lisp), and [tests](../../host/test.lisp).
