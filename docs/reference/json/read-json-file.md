# `han.json:read-json-file`

[简体中文](read-json-file.zh-CN.md)

*Function*

## Syntax

```text
(han.json:read-json-file path) → value
```

## Description

Read and parse a UTF-8 JSON document, with the same behavior and return value as `parse-json-file`. The result can be any JSON value, including an array or scalar. The host stream decoder handles invalid UTF-8 bytes. Once decoded, JSON syntax errors signal `json-error`. Opening a missing file signals a file error.

## Examples

Read an explicit null from a file and keep the presence flag.

```lisp
(uiop:with-temporary-file (:stream out :pathname path :external-format :utf-8)
  (write-string "{\"timeout\":null}" out)
  :close-stream
  (multiple-value-list (han.json:get-json (han.json:read-json-file path) "timeout")))
;; => (:NULL T)
```

A top-level Unicode string can be the entire file.

```lisp
(uiop:with-temporary-file (:stream out :pathname path :external-format :utf-8)
  (write-string "\"样本\"" out)
  :close-stream
  (han.json:read-json-file path))
;; => "样本"
```

[`parse-json-file`](parse-json-file.md) · [`get-json`](get-json.md) · [Source](../../../json/core.lisp#L384) · [Index](../README.md)
