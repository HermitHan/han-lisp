# `han.host:shell-command-argv`

[简体中文](shell-command-argv.zh-CN.md)

*Function*

## Syntax

```text
(han.host:shell-command-argv command &optional shell) → list
```

## Description

Builds the list `(shell-path "-c" command)` for a subsequent process call. With no shell supplied, it uses the first match for `bash`, then tries `sh`. With an explicit shell it probes the supplied file directly and preserves it in the result. It signals an error if no default shell is found or the chosen file does not exist. The command is passed to the shell as one argument.

## Examples

Inspect the arguments for an explicitly chosen shell before starting a process.

```lisp
(han.host:shell-command-argv "printf '%s' 'a b'" "/bin/sh")
;; => ("/bin/sh" "-c" "printf '%s' 'a b'")
```

Use the default shell to run a command and collect its output and exit code.

```lisp
(han.host:run-program-sync
 (han.host:shell-command-argv "printf '%s' 'a b'"))
;; => values ("a b" "" 0)
```

[`han.os:run-shell-command`](../os/run-shell-command.md) · [`han.host:run-program-sync`](run-program-sync.md) · [common.lisp](../../../host/common.lisp) · [Index](../README.md)
