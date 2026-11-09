# `han.args:version`

[简体中文](version.zh-CN.md)

*Function*

## Syntax

```text
(han.args:version &optional (stream *standard-output*)) → string
```

## Description

Return the `han.args` version string. By default also print a line with the package name and its version. Pass an output stream to redirect that line, or `nil` to suppress printing.

## Examples

Read the bare version string for use in another message.

```lisp
(han.args:version nil)
;; => "0.2.0"
```

Inspect the formatted version line sent to a designated stream.

```lisp
(let* ((stream (make-string-output-stream))
       (version (han.args:version stream)))
  (values version (string-right-trim '(#\Newline) (get-output-stream-string stream))))
;; => values ("0.2.0" "han.args v0.2.0")
```

[`han.args:help`](help.md) · [Source](../../../args/package.lisp) · [Index](../README.md)
