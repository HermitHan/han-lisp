# `han.host:help`

*Function · 函数*

## Syntax · 语法

```text
(han.host:help &optional (stream *standard-output*)) → text
```

## Description · 说明

Returns the package's built-in guide as a string. By default it also writes the guide to standard output. Pass an output stream to redirect it or `nil` for the string alone.

返回本包内置帮助字符串，默认同时将内容写到标准输出。传输出流可重定向，传 `nil` 只取得文本。

## Examples · 示例

Retrieve the help text silently and search it for `run-program-sync`.

静默取得帮助文本，在其中查找 `run-program-sync`。

```lisp
(let ((text (han.host:help nil)))
  (and (stringp text) (not (null (search "run-program-sync" text)))))
;; => T
```

Send the guide to a caller-owned stream for a help panel.

将帮助写入调用方的流，以便在帮助面板中显示。

```lisp
(let ((text (han.host:help nil)))
  (string= text (with-output-to-string (destination)
                  (han.host:help destination))))
;; => T
```

[`han.host:version`](version.md) · [`han.host:run-program-sync`](run-program-sync.md) · [package.lisp](../../../host/package.lisp) · [Index · 索引](../README.md)
