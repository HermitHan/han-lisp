# `han.test:version`

*Function · 函数*

## Syntax · 语法

```text
(han.test:version &optional (stream *standard-output*)) → version-string
```

## Description · 说明

Return the version string declared by the han.test package. The default stream prints a line with the package name and version. Pass `nil` for silent retrieval.

返回 han.test 包声明的版本字符串。默认还会向标准输出打印含包名与版本的一行文字。传入 `nil` 时只返回版本字符串。

## Examples · 示例

Read the package version quietly for a programmatic check.

静默读取包版本，供程序检查。

```lisp
(han.test:version nil)
;; => "0.1.0"
```

Capture the human-readable banner while retaining the version string separately.

捕获面向读者的版本提示行，同时保留可供程序处理的版本字符串。

```lisp
(let* ((out (make-string-output-stream))
       (version (han.test:version out))
       (banner (get-output-stream-string out)))
  (list version (with-input-from-string (in banner) (read-line in))))
;; => ("0.1.0" "han.test v0.1.0")
```

[`help`](help.md) · [Source · 源码](../../../test/package.lisp#L53) · [Index · 索引](../README.md)
