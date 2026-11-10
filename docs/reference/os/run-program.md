# `han.os:run-program`

[简体中文](run-program.zh-CN.md)

*Function*

## Syntax

```text
(han.os:run-program command &key input (output :string) (error-output :string) (ignore-error-status t)) → stdout, stderr, exit-code
```

## Description

Runs a program synchronously through `han.host:run-program-sync`. A list of strings supplies argv and a command string uses shell syntax. By default stdin sees EOF and both outputs are captured as strings. Pass a character input stream to send literal text. Nonzero integer exit codes are returned by default or signal an error if `ignore-error-status` is `nil`. Redirected output streams receive their text after completion.

With `:input t`, LispWorks, ECL and CCL wait for EOF on standard input before starting the child. CCL decodes captured output as UTF-8. The other adapters use the host’s default external format. See the [host function](../host/run-program-sync.md) for stream behavior.

On ECL and CCL, passing `:stream` for any synchronous I/O channel signals `simple-error` before launch. For a live pipe, use [han.host:run-program](../host/run-program.md).

## Examples

Send a string to `cat` and collect standard output, standard error and the exit code.

```lisp
(with-input-from-string (input "two words")
  (multiple-value-list (han.os:run-program '("/bin/cat") :input input)))
;; => ("two words" "" 0)
```

For portable argv calls, supply the executable’s full path. If you have only its name, use [`han.host:find-executable`](../host/find-executable.md) and check the result before launching. The remaining arguments are passed literally, including spaces and shell metacharacters.

```lisp
(let ((program (or (han.host:find-executable "printf")
                   (error "Cannot find printf"))))
  (han.os:run-program (list program "%s" "a $HOME *")))
;; => values ("a $HOME *" "" 0)
```

Make a nonzero worker exit fail the enclosing Lisp operation.

```lisp
(han.os:run-program '("/bin/sh" "-c" "exit 11") :ignore-error-status nil)
;; signals simple-error
```

[`han.os:run-shell-command`](run-shell-command.md) · [`han.host:run-program-sync`](../host/run-program-sync.md) · [run-shell.lisp](../../../os/run-shell.lisp) · [Index](../README.md)
