# `han.os:load-lines`

[简体中文](load-lines.zh-CN.md)

*Function*

## Syntax

```text
(han.os:load-lines input) → list of line strings
```

## Description

Reads the remaining contents of a character stream, or opens a string filename or pathname using UTF-8. Returns lines in order without terminators. A supplied stream is left open. A missing file or an unsupported input designator signals an error.

## Examples

Read a blank line between two lines of Chinese text and keep its place in the result.

```lisp
(with-input-from-string (input (format nil "甲~%~%乙~%"))
  (han.os:load-lines input))
;; => ("甲" "" "乙")
```

Read a UTF-8 file produced by another writer. Adjacent newlines yield an empty row.

```lisp
(uiop:with-temporary-file (:pathname file)
  (han.host:append-utf8-line file "数据")
  (han.host:append-utf8-line file "")
  (han.os:load-lines (namestring file)))
;; => ("数据" "")
```

Report a missing input file before running the parser.

```lisp
(uiop:with-temporary-file (:pathname file)
  (han.os:load-lines (han.path:join-path file "absent.txt")))
;; signals simple-error
```

[`han.os:load-string`](load-string.md) · [`han.os:keep-read-line`](keep-read-line.md) · [io.lisp](../../../os/io.lisp) · [Index](../README.md)
