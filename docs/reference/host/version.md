# `han.host:version`

[简体中文](version.zh-CN.md)

*Function*

## Syntax

```text
(han.host:version &optional (stream *standard-output*)) → version-string
```

## Description

Returns the package version string. By default it also prints a labeled version line and a newline. A `nil` stream suppresses printing.

## Examples

Request the version silently and check that the result is a string.

```lisp
(stringp (han.host:version nil))
;; => T
```

Capture the printable banner for a command's version report.

```lisp
(let ((output (with-output-to-string (stream)
                (han.host:version stream))))
  (string= output (format nil "han.host v~A~%" (han.host:version nil))))
;; => T
```

[`han.host:help`](help.md) · [package.lisp](../../../host/package.lisp) · [Index](../README.md)
