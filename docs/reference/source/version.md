# `han.source:version`

*Function · 函数*

## Syntax · 语法

```text
(han.source:version &optional (stream *standard-output*)) → version-string
```

## Description · 说明

Returns this package’s version as a string. When `stream` is non-nil it also writes a labeled version line there. Use the silent form when a program needs just the value.

返回当前包的版本字符串。`stream` 非空时还会写出带包名的版本行。程序需要直接比较版本值时可以使用静默形式。

## Examples · 示例

**Retrieve the version string without printing a banner · 静默读取包的版本字符串**

```lisp
(han.source:version nil)
;; => "0.1.0"
```

**Capture the formatted version line as well as the bare value · 同时取得版本值及写到流中的版本行**

```lisp
(let ((out (make-string-output-stream)))
  (let ((number (han.source:version out)))
    (string= (get-output-stream-string out)
             (format nil "han.source v~A~%" number))))
;; => T
```

[`han.source:help`](help.md) · [Source · 源码](../../../source/package.lisp) · [Index · 索引](../README.md)
