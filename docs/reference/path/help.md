# `han.path:help`

*Function · 函数*

## Syntax · 语法

```text
(han.path:help &optional (stream *standard-output*)) → text
```

## Description · 说明

Returns the package’s built-in help text. By default it also writes that text to standard output. Supply a character output stream to capture it or `nil` to retrieve it silently.

返回包内置的帮助字符串。默认也将帮助写到标准输出；可以指定字符输出流，也可以传入 `nil` 只取字符串。

## Examples · 示例

Read the package help into a string without writing to standard output.

把包的帮助文本读入字符串，同时保持标准输出安静。

```lisp
(let ((text (han.path:help nil)))
  (and (stringp text) (plusp (length text))))
;; => T
```

Capture the path guide for display in an editor's help buffer.

把路径帮助直接写入可供编辑器显示的缓冲流。

```lisp
(let ((text (han.path:help nil)))
  (string= text (with-output-to-string (destination)
                  (han.path:help destination))))
;; => T
```

[`han.path:version`](version.md) · [Source · 源码](../../../path/package.lisp) · [Index · 索引](../README.md)
