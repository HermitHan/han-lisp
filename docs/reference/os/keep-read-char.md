# `han.os:keep-read-char`

[简体中文](keep-read-char.zh-CN.md)

*Function*

## Syntax

```text
(han.os:keep-read-char &optional (stream *standard-input*) (limit nil)) → list of characters
```

## Description

Reads characters in input order, including whitespace and newlines. A `nil` limit reads to EOF. A numeric limit permits another read while the number collected is less than that limit. A function limit receives the reverse-order accumulator before each read, initially `nil`. The remainder stays in the caller's stream.

## Examples

Read two characters and leave the third for the next reader.

```lisp
(with-input-from-string (input "abc")
  (list (han.os:keep-read-char input 2) (read-char input)))
;; => ((#\a #\b) #\c)
```

Read a delimited header through its separator, leaving the payload for a different decoder.

```lisp
(with-input-from-string (in "id:AB")
  (list (coerce (han.os:keep-read-char in
                  (lambda (rev) (not (eql (first rev) #\:)))) 'string)
        (coerce (han.os:keep-read-char in) 'string)))
;; => ("id:" "AB")
```

[`han.os:keep-read-line`](keep-read-line.md) · [`han.os:keep-read`](keep-read.md) · [io.lisp](../../../os/io.lisp) · [Index](../README.md)
