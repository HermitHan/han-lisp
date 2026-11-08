# `han.os:help`

*Function · 函数*

## Syntax · 语法

```text
(han.os:help &optional (stream *standard-output*)) → text
```

## Description · 说明

Returns the package guide as a string, also writing it to standard output by default. Use a supplied character output stream to redirect it or `nil` to read the text without printing.

返回本包的帮助字符串，默认也会写到标准输出。可传入字符输出流重定向，或传 `nil` 只取文本。

## Examples · 示例

Search the returned help text for the shell command runner without printing the help.

静默读取帮助文本，在其中查找运行 shell 命令的函数名。

```lisp
(let ((text (han.os:help nil)))
  (not (null (search "run-shell-command" text))))
;; => T
```

Write the OS command guide to an application-owned text stream.

将 OS 命令帮助写入应用自己的文本流。

```lisp
(let ((text (han.os:help nil)))
  (string= text (with-output-to-string (destination)
                  (han.os:help destination))))
;; => T
```

[`han.os:version`](version.md) · [`han.os:run-shell-command`](run-shell-command.md) · [package.lisp](../../../os/package.lisp) · [Index · 索引](../README.md)
