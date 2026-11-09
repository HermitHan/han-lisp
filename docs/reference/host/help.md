# `han.host:help`

[简体中文](help.zh-CN.md)

*Function*

## Syntax

```text
(han.host:help &optional (stream *standard-output*)) → text
```

## Description

Returns the package's built-in guide as a string. By default it also writes the guide to standard output. Pass an output stream to redirect it or `nil` for the string alone.

## Examples

Retrieve the help text silently and search it for `run-program-sync`.

```lisp
(let ((text (han.host:help nil)))
  (and (stringp text) (not (null (search "run-program-sync" text)))))
;; => T
```

Send the guide to a caller-owned stream for a help panel.

```lisp
(let ((text (han.host:help nil)))
  (string= text (with-output-to-string (destination)
                  (han.host:help destination))))
;; => T
```

[`han.host:version`](version.md) · [`han.host:run-program-sync`](run-program-sync.md) · [package.lisp](../../../host/package.lisp) · [Index](../README.md)
