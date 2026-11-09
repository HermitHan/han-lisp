# `han.os:help`

[简体中文](help.zh-CN.md)

*Function*

## Syntax

```text
(han.os:help &optional (stream *standard-output*)) → text
```

## Description

Returns the package guide as a string, also writing it to standard output by default. Use a supplied character output stream to redirect it or `nil` to read the text without printing.

## Examples

Search the returned help text for the shell command runner without printing the help.

```lisp
(let ((text (han.os:help nil)))
  (not (null (search "run-shell-command" text))))
;; => T
```

Write the OS command guide to an application-owned text stream.

```lisp
(let ((text (han.os:help nil)))
  (string= text (with-output-to-string (destination)
                  (han.os:help destination))))
;; => T
```

[`han.os:version`](version.md) · [`han.os:run-shell-command`](run-shell-command.md) · [package.lisp](../../../os/package.lisp) · [Index](../README.md)
