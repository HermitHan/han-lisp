# `han.json:write-json`

[简体中文](write-json.zh-CN.md)

*Function*

## Syntax

```text
(han.json:write-json value stream &key (indent 2)) → value
```

## Description

Write JSON to the supplied character output stream and return the original Lisp value. The caller owns the stream. Pretty output ends in a newline. `:indent nil` writes compactly. An unsupported nested value can signal `json-error` after part of the document has already been written.

## Examples

Capture both the return value and the characters written to a stream.

```lisp
(let* ((out (make-string-output-stream))
       (value (han.json:write-json :null out :indent nil)))
  (list value (get-output-stream-string out)))
;; => (:NULL "null")
```

Build a JSON Lines stream by adding a newline after each compact value.

```lisp
(let ((text (with-output-to-string (out)
              (dolist (value '(t :null))
                (han.json:write-json value out :indent nil)
                (terpri out)))))
  (with-input-from-string (in text) (han.os:keep-read-line in)))
;; => ("true" "null")
```

[`encode-json`](encode-json.md) · [`write-json-file`](write-json-file.md) · [Source](../../../json/core.lisp#L488) · [Index](../README.md)
