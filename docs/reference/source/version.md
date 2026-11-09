# `han.source:version`

[简体中文](version.zh-CN.md)

*Function*

## Syntax

```text
(han.source:version &optional (stream *standard-output*)) → version-string
```

## Description

Returns this package’s version as a string. When `stream` is non-nil it also writes a labeled version line there. Use the silent form when a program needs just the value.

## Examples

**Retrieve the version string without printing a banner**

```lisp
(han.source:version nil)
;; => "0.2.0"
```

**Capture the formatted version line as well as the bare value**

```lisp
(let ((out (make-string-output-stream)))
  (let ((number (han.source:version out)))
    (string= (get-output-stream-string out)
             (format nil "han.source v~A~%" number))))
;; => T
```

[`han.source:help`](help.md) · [Source](../../../source/package.lisp) · [Index](../README.md)
