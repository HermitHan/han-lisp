# `han.os:version`

*Function · 函数*

## Syntax · 语法

```text
(han.os:version &optional (stream *standard-output*)) → version-string
```

## Description · 说明

Returns the package version string. If `stream` is non-nil, it also writes a labeled version line to that stream. Supplying `nil` suppresses printing.

返回包的版本字符串。`stream` 非空时也向该流写入一行包含包名的版本信息，传 `nil` 则关闭打印。

## Examples · 示例

Read the OS package version without printing and check that it is a nonempty string.

静默读取 OS 包的版本号，检查它是非空字符串。

```lisp
(let ((value (han.os:version nil)))
  (and (stringp value) (plusp (length value))))
;; => T
```

Produce a user-visible version banner while continuing to use the returned plain version number.

生成人可读的版本横幅，同时仍可取得仅含版本号的字符串。

```lisp
(let ((output (with-output-to-string (stream)
                (han.os:version stream))))
  (string= output (format nil "han.os v~A~%" (han.os:version nil))))
;; => T
```

[`han.os:help`](help.md) · [package.lisp](../../../os/package.lisp) · [Index · 索引](../README.md)
