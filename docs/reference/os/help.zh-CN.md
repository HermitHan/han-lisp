# `han.os:help`

[English](help.md)

*函数*

## 语法

```text
(han.os:help &optional (stream *standard-output*)) → text
```

## 说明

返回本包的帮助字符串，默认也会写到标准输出。可传入字符输出流重定向，或传 `nil` 只取文本。

## 示例

静默读取帮助文本，在其中查找运行 shell 命令的函数名。

```lisp
(let ((text (han.os:help nil)))
  (not (null (search "run-shell-command" text))))
;; => T
```

将 OS 命令帮助写入应用自己的文本流。

```lisp
(let ((text (han.os:help nil)))
  (string= text (with-output-to-string (destination)
                  (han.os:help destination))))
;; => T
```

[`han.os:version`](version.zh-CN.md) · [`han.os:run-shell-command`](run-shell-command.zh-CN.md) · [package.lisp](../../../os/package.lisp) · [索引](../README.zh-CN.md)
