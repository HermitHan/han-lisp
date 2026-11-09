# `han.path:version`

[简体中文](version.zh-CN.md)

*Function*

## Syntax

```text
(han.path:version &optional (stream *standard-output*)) → version-string
```

## Description

Returns this package’s version as a string. When `stream` is non-nil it also writes a labeled version line there. Use the silent form when a program needs just the value.

## Examples

Read the path package’s version string silently.

```lisp
(han.path:version nil)
;; => "0.2.0"
```

Embed the formatted package version in a tool's diagnostic output.

```lisp
(let ((output (with-output-to-string (stream)
                (han.path:version stream))))
  (string= output (format nil "han.path v~A~%" (han.path:version nil))))
;; => T
```

[`han.path:help`](help.md) · [Source](../../../path/package.lisp) · [Index](../README.md)
