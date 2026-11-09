# `han.host:with-character-output-to-string`

[简体中文](with-character-output-to-string.zh-CN.md)

*Macro*

## Syntax

```text
(han.host:with-character-output-to-string (stream) &body body) → string
```

## Description

Binds `stream` to a character output stream for the body and returns the collected string. The backing buffer has element type `character`, so non-ASCII text can coexist with ASCII even when the implementation normally chooses a narrower string.

## Examples

Collect Chinese text and a single Latin letter in the same string.

```lisp
(han.host:with-character-output-to-string (out)
  (write-string "路径/" out)
  (write-char #\A out))
;; => "路径/A"
```

Render a sequence of records through an ordinary stream-writing function.

```lisp
(let ((text (han.host:with-character-output-to-string (out)
              (dolist (field '("id" "值"))
                (write-line field out)))))
  (with-input-from-string (in text)
    (han.os:load-lines in)))
;; => ("id" "值")
```

[`han.host:prepare-runtime-io`](prepare-runtime-io.md) · [`han.host:append-utf8-line`](append-utf8-line.md) · [common.lisp](../../../host/common.lisp) · [Index](../README.md)
