# `han.json:write-json-file`

[简体中文](write-json-file.zh-CN.md)

*Function*

## Syntax

```text
(han.json:write-json-file path value &key (indent 2)) → path
```

## Description

Create missing parent directories and write the value to a UTF-8 file, superseding an existing destination. Return `path` as supplied. Formatting follows `write-json`. Serialization and file errors propagate, so a failed write can leave a partial destination. The example uses a UIOP temporary pathname.

## Examples

Write an array to a temporary destination and decode it again.

```lisp
(uiop:with-temporary-file (:pathname path)
  (let ((result (han.json:write-json-file path (han.json:json-array 2 3) :indent nil)))
    (list (equal path result)
          (coerce (han.json:read-json-file path) 'list))))
;; => (T (2 3))
```

A second write replaces the previous document at the same temporary path.

```lisp
(uiop:with-temporary-file (:pathname path)
  (han.json:write-json-file path (han.json:json-array 1 2 3))
  (han.json:write-json-file path :null :indent nil)
  (han.host:with-open-utf8-file (in path)
    (read-line in)))
;; => "null"
```

[`write-json`](write-json.md) · [`read-json-file`](read-json-file.md) · [Source](../../../json/core.lisp#L502) · [Index](../README.md)
