# han.os

[User guide](README.md) · [简体中文](os.zh-CN.md) · [Package symbol index](../reference/README.md#os)

Use `han.os` when a program needs to read a stream, inspect the environment, or collect the output of a command. All names in the tables belong to `han.os`.

## Read some lines, then keep going

Supply an existing stream to consume just part of it and continue from the same position.

```lisp
(with-input-from-string (input (format nil "alpha~%beta~%gamma~%"))
  (list (han.os:keep-read-line input 2)
        (han.os:load-lines input)))
;; => (("alpha" "beta") ("gamma"))
```

| Operation | Input and result |
| --- | --- |
| [`keep-read &optional stream limit`](../reference/os/keep-read.md), [`keep-read-char &optional stream limit`](../reference/os/keep-read-char.md), [`keep-read-line &optional stream limit`](../reference/os/keep-read-line.md) | Return a list of Lisp objects, characters, or lines in input order. Each defaults to `*standard-input*`. A `nil` limit reads to EOF. An integer limit caps the number read. A function receives the accumulated list in **reverse** order before every read, including the first, and returns true to continue. |
| [`load-lines input`](../reference/os/load-lines.md) | Reads all remaining lines from a character stream, or opens a filename (string or pathname) as UTF-8. Returns a list of strings without line endings. A missing file signals an error. The caller retains ownership of a supplied stream. |
| [`load-string input`](../reference/os/load-string.md) | Accepts the same input and joins the lines with a newline **between** adjacent entries. A final line terminator in the input is omitted. |

`keep-read` uses the Common Lisp reader. Use it for Lisp data with the intended reader settings. `keep-read-line` is suitable for ordinary text.

## Pass arguments to a program

A command list keeps the program name and every argument separate. To supply literal text on stdin, pass a character stream.

```lisp
(with-input-from-string (input "two words")
  (multiple-value-list
   (han.os:run-program '("/bin/cat") :input input)))
;; => ("two words" "" 0)
```

| Operation | Input and result |
| --- | --- |
| [`run-program command &key input (output :string) (error-output :string) (ignore-error-status t)`](../reference/os/run-program.md) | Runs synchronously and returns stdout, stderr, and the exit code as **three values**. A nonempty list of strings supplies argv. A command string is interpreted as shell syntax. `input` defaults to EOF. Use `t` for standard input. Each output defaults to a captured string. With `t` or an output stream, that channel is replayed after completion and its returned value is `nil`. Passing `:ignore-error-status nil` signals an error for a nonzero integer exit code. |
| [`escape-sh-token value`](../reference/os/escape-sh-token.md) | Returns one POSIX-shell-quoted token, including surrounding quotes. `nil` becomes a quoted empty string. Use this only when inserting one argument into shell text. |
| [`run-shell-command command &key (wait t) (lines t) shell`](../reference/os/run-shell-command.md) | Runs shell text with `-c`. A supplied `shell` is an executable file path. The default searches for `bash` and then `sh`. With `wait` true, returns stdout lines, stderr lines, and the exit code. Use `:lines nil` for strings that preserve final newlines. |

A shell is useful for redirections. The quoted argument below contains both an apostrophe and a dollar sign. Each reaches `printf` literally. The caller can examine diagnostics even when the command exits with a nonzero code.

```lisp
(multiple-value-list
 (han.os:run-shell-command
  (format nil "printf '%s\\n' ~A; printf 'note\\n' >&2; exit 3"
          (han.os:escape-sh-token "l'été $HOME"))
  :shell "/bin/sh"))
;; => (("l'été $HOME") ("note") 3)
```

With `:wait nil`, `run-shell-command` returns **four values** in order, the stdout stream, the stderr stream, `nil` in the exit-code position, and a `han.host:host-process`. In this mode `lines` has no effect. The caller consumes the pipes, calls `han.host:process-wait` to collect completion, reads `han.host:process-exit-code`, and releases resources with `han.host:process-close`. If the child may write heavily to both streams, arrange to drain both or use synchronous capture. See [process control](host.md).

## Find configuration and executables

| Operation | Result |
| --- | --- |
| [`getenv-default name default`](../reference/os/getenv-default.md), [`require-env name`](../reference/os/require-env.md) | Read the named variable as a string. The first returns the supplied fallback when unset, the second signals an error. A variable set to the empty string counts as present. |
| [`current-user &optional (default "World")`](../reference/os/current-user.md) | Reads `USER`, then `LOGNAME`, then uses the supplied default. |
| [`current-directory`](../reference/os/current-directory.md), [`home-directory`](../reference/os/home-directory.md) | Return a directory namestring or `nil`. The home query tries an existing `HOME` and then the Lisp user home directory. |
| [`find-executable program`](../reference/os/find-executable.md) | For a pathname-like string, tries it directly. For a bare name, searches `PATH` and then built-in Unix directories. The primary value is the first matching file or `nil`. Further matches can be returned as additional values. The lookup tests file existence only. |
| [`help &optional stream`](../reference/os/help.md), [`version &optional stream`](../reference/os/version.md) | Return the help text or version string and print to `stream` (default `*standard-output*`). Pass `nil` for just the string. |

See the [package definition](../../os/package.lisp) and [tests](../../os/test.lisp).
