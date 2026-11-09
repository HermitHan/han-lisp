# `han.test:help`

[简体中文](help.zh-CN.md)

*Function*

## Syntax

```text
(han.test:help &optional (stream *standard-output*)) → text
```

## Description

Return the package’s built-in help string with its registration, runner and assertion interfaces. The default also writes it to standard output. Pass `nil` to inspect the text silently, or a character output stream to capture it.

## Examples

Search the returned help text without writing to standard output.

```lisp
(let ((text (han.test:help nil)))
  (and (stringp text) (not (null (search "run-all-tests" text)))))
;; => T
```

Route the help to a caller-owned stream and compare the captured text with the return value.

```lisp
(let ((out (make-string-output-stream)))
  (let ((text (han.test:help out)))
    (string= text (get-output-stream-string out))))
;; => T
```

[`version`](version.md) · [Source](../../../test/package.lisp#L47) · [Index](../README.md)
