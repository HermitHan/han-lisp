# `han.path:help`

[简体中文](help.zh-CN.md)

*Function*

## Syntax

```text
(han.path:help &optional (stream *standard-output*)) → text
```

## Description

Returns the package’s built-in help text. By default it also writes that text to standard output. Supply a character output stream to capture it or `nil` to retrieve it silently.

## Examples

Read the package help into a string without writing to standard output.

```lisp
(let ((text (han.path:help nil)))
  (and (stringp text) (plusp (length text))))
;; => T
```

Capture the path guide for display in an editor's help buffer.

```lisp
(let ((text (han.path:help nil)))
  (string= text (with-output-to-string (destination)
                  (han.path:help destination))))
;; => T
```

[`han.path:version`](version.md) · [Source](../../../path/package.lisp) · [Index](../README.md)
