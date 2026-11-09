# `han.os:load-string`

[简体中文](load-string.zh-CN.md)

*Function*

## Syntax

```text
(han.os:load-string input) → string
```

## Description

Accepts the same character stream or UTF-8 filename as `load-lines`. Joins the resulting lines with a single newline between adjacent items. This loses the distinction between a final line ending and an unterminated last line. Empty input yields an empty string.

## Examples

Read two lines as one string and check which newline is retained.

```lisp
(with-input-from-string (input (format nil "a~%b~%"))
  (string= (han.os:load-string input) (format nil "a~%b")))
;; => T
```

Combine UTF-8 file lines into display text and retain an empty middle line.

```lisp
(uiop:with-temporary-file (:pathname file)
  (dolist (line '("甲" "" "乙")) (han.host:append-utf8-line file line))
  (string= (han.os:load-string file) (format nil "甲~%~%乙")))
;; => T
```

Use only the unread suffix when a parser has already consumed a stream header.

```lisp
(with-input-from-string (in (format nil "version 1~%正文~%"))
  (read-line in)
  (han.os:load-string in))
;; => "正文"
```

[`han.os:load-lines`](load-lines.md) · [`han.os:keep-read-line`](keep-read-line.md) · [io.lisp](../../../os/io.lisp) · [Index](../README.md)
