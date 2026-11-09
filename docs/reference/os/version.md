# `han.os:version`

[简体中文](version.zh-CN.md)

*Function*

## Syntax

```text
(han.os:version &optional (stream *standard-output*)) → version-string
```

## Description

Returns the package version string. If `stream` is non-nil, it also writes a labeled version line to that stream. Supplying `nil` suppresses printing.

## Examples

Read the OS package version without printing and check that it is a nonempty string.

```lisp
(let ((value (han.os:version nil)))
  (and (stringp value) (plusp (length value))))
;; => T
```

Produce a user-visible version banner while continuing to use the returned plain version number.

```lisp
(let ((output (with-output-to-string (stream)
                (han.os:version stream))))
  (string= output (format nil "han.os v~A~%" (han.os:version nil))))
;; => T
```

[`han.os:help`](help.md) · [package.lisp](../../../os/package.lisp) · [Index](../README.md)
