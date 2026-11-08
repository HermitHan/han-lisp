# `han.path:version`

*Function · 函数*

## Syntax · 语法

```text
(han.path:version &optional (stream *standard-output*)) → version-string
```

## Description · 说明

Returns this package’s version as a string. When `stream` is non-nil it also writes a labeled version line there. Use the silent form when a program needs just the value.

返回当前包的版本字符串。`stream` 非空时还会写出带包名的版本行。程序需要直接比较版本值时可以使用静默形式。

## Examples · 示例

Read the path package’s version string silently.

静默取得路径包的版本字符串。

```lisp
(han.path:version nil)
;; => "0.1.0"
```

Embed the formatted package version in a tool's diagnostic output.

把格式化的包版本嵌入工具的诊断输出。

```lisp
(let ((output (with-output-to-string (stream)
                (han.path:version stream))))
  (string= output (format nil "han.path v~A~%" (han.path:version nil))))
;; => T
```

[`han.path:help`](help.md) · [Source · 源码](../../../path/package.lisp) · [Index · 索引](../README.md)
