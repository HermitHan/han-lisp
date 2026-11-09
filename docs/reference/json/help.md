# `han.json:help`

[简体中文](help.zh-CN.md)

*Function*

## Syntax

```text
(han.json:help &optional (stream *standard-output*)) → text
```

## Description

Return the package’s built-in help string with the JSON data model, construction and encoding examples. With the default stream the same text is printed to standard output. Pass `nil` to retrieve the string silently.

## Examples

Search the returned help text without writing to standard output.

```lisp
(let ((text (han.json:help nil)))
  (and (stringp text) (not (null (search "get-json" text)))))
;; => T
```

Route the help to a caller-owned stream and compare the captured text with the return value.

```lisp
(let ((out (make-string-output-stream)))
  (let ((text (han.json:help out)))
    (string= text (get-output-stream-string out))))
;; => T
```

[`version`](version.md) · [Source](../../../json/package.lisp#L60) · [Index](../README.md)
