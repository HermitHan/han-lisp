# `han.source:help`

[简体中文](help.zh-CN.md)

*Function*

## Syntax

```text
(han.source:help &optional (stream *standard-output*)) → text
```

## Description

Returns the package’s built-in help text. By default it also writes that text to standard output. Supply a character output stream to capture it or `nil` to retrieve it silently.

## Examples

**Retrieve the help text silently and check that it is nonempty**

```lisp
(let ((text (han.source:help nil)))
  (and (stringp text) (plusp (length text))))
;; => T
```

**Send the same text to a chosen stream**

```lisp
(let ((stream (make-string-output-stream)))
  (let ((text (han.source:help stream)))
    (string= text (get-output-stream-string stream))))
;; => T
```

[`han.source:version`](version.md) · [Source](../../../source/package.lisp) · [Index](../README.md)
