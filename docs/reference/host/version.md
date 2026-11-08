# `han.host:version`

*Function · 函数*

## Syntax · 语法

```text
(han.host:version &optional (stream *standard-output*)) → version-string
```

## Description · 说明

Returns the package version string. By default it also prints a labeled version line and a newline. A `nil` stream suppresses printing.

返回包的版本字符串。默认同时输出一行带包名的版本信息和换行。传 `nil` 关闭打印。

## Examples · 示例

Request the version silently and check that the result is a string.

静默读取版本号，确认返回值是字符串。

```lisp
(stringp (han.host:version nil))
;; => T
```

Capture the printable banner for a command's version report.

捕获带包名的版本行，组装命令的版本报告。

```lisp
(let ((output (with-output-to-string (stream)
                (han.host:version stream))))
  (string= output (format nil "han.host v~A~%" (han.host:version nil))))
;; => T
```

[`han.host:help`](help.md) · [package.lisp](../../../host/package.lisp) · [Index · 索引](../README.md)
