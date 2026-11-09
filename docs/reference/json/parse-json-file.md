# `han.json:parse-json-file`

[简体中文](parse-json-file.zh-CN.md)

*Function*

## Syntax

```text
(han.json:parse-json-file path) → value
```

## Description

Open the pathname designator for character input with UTF-8 encoding, read its entire contents, then parse one JSON value. The input stream is closed on exit. Syntax errors signal `json-error`. File access errors propagate; handling of malformed UTF-8 bytes belongs to the host stream decoder. The example uses a temporary file managed by the UIOP included with ASDF.

For a file containing `22 F0 9F`, ECL 26.5.5 reaches EOF during UTF-8 decoding. The parser then signals `han.json:json-error` for the unclosed string. SBCL and LispWorks signal their stream-decoding errors while reading those bytes. [UTF-8 input](../host/with-open-utf8-file.md)

## Examples

Read an array from a temporary file and index its last element.

```lisp
(uiop:with-temporary-file (:stream out :pathname path :external-format :utf-8)
  (write-string "[3,5,8]" out)
  :close-stream
  (aref (han.json:parse-json-file path) 2))
;; => 8
```

Malformed syntax in an existing file reaches the same parser as a string.

```lisp
(uiop:with-temporary-file (:stream out :pathname path :external-format :utf-8)
  (write-string "[1,]" out)
  :close-stream
  (han.json:parse-json-file path))
;; signals han.json:json-error
```

[`parse-json`](parse-json.md) · [`read-json-file`](read-json-file.md) · [`write-json-file`](write-json-file.md) · [Source](../../../json/core.lisp#L381) · [Index](../README.md)
