# `han.args:help`

[简体中文](help.zh-CN.md)

*Function*

## Syntax

```text
(han.args:help &optional (stream *standard-output*)) → string
```

## Description

Return the package's built-in help text covering specifications, input parsing, binding, and lookup. When `stream` is non-nil, write the same text there. Pass `nil` to use the returned string without printing.

## Examples

Search the built-in help without printing it.

```lisp
(let ((text (han.args:help nil)))
  (not (null (search "parse-args-input" text))))
;; => t
```

Capture the printed help and compare it with the returned text.

```lisp
(let* ((stream (make-string-output-stream))
       (text (han.args:help stream)))
  (string= text (get-output-stream-string stream)))
;; => t
```

[`han.args:version`](version.md) · [`han.args:parse-args-input`](parse-args-input.md) · [Source](../../../args/package.lisp) · [Index](../README.md)
