# `han.os:keep-read-line`

[简体中文](keep-read-line.zh-CN.md)

*Function*

## Syntax

```text
(han.os:keep-read-line &optional (stream *standard-input*) (limit nil)) → list of line strings
```

## Description

Reads lines in order and strips their line terminators. A `nil` limit reads to EOF, a count bounds the lines, and a function limit can inspect accumulated lines in reverse order before each read. In the example the marker is included in the first result and the following line remains in the stream.

## Examples

Read through the `END` marker and leave the following line in the stream.

```lisp
(with-input-from-string (input (format nil "one~%END~%three"))
  (list (han.os:keep-read-line input
                               (lambda (reversed)
                                 (not (equal (first reversed) "END"))))
        (read-line input)))
;; => (("one" "END") "three")
```

Read a header and preserve a blank data row from the remaining stream.

```lisp
(with-input-from-string (in (format nil "column~%~%second~%"))
  (list (han.os:keep-read-line in 1) (han.os:keep-read-line in)))
;; => (("column") ("" "second"))
```

[`han.os:load-lines`](load-lines.md) · [`han.os:keep-read-char`](keep-read-char.md) · [io.lisp](../../../os/io.lisp) · [Index](../README.md)
