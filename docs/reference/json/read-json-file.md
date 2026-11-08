# `han.json:read-json-file`

*Function · 函数*

## Syntax · 语法

```text
(han.json:read-json-file path) → value
```

## Description · 说明

Read and parse a UTF-8 JSON document, with the same behavior and return value as `parse-json-file`. The result can be any JSON value, including an array or scalar. Malformed JSON signals `json-error`, and opening a missing file signals a file error. The example uses UIOP to remove the temporary file after the read.

读取并解析 UTF-8 JSON 文档，行为与返回值同 `parse-json-file`。顶层可以是任何 JSON 值，包括数组和标量。非法 JSON 触发 `json-error`，打开不存在的文件会发出文件错误。示例通过 UIOP 在读取后清理临时文件。

## Examples · 示例

Read an explicit null from a file and keep the presence flag.

从文件读取显式空值，并保留字段存在标志。

```lisp
(uiop:with-temporary-file (:stream out :pathname path :external-format :utf-8)
  (write-string "{\"timeout\":null}" out)
  :close-stream
  (multiple-value-list (han.json:get-json (han.json:read-json-file path) "timeout")))
;; => (:NULL T)
```

A top-level Unicode string can be the entire file.

整个文件可以只包含一个 Unicode 字符串。

```lisp
(uiop:with-temporary-file (:stream out :pathname path :external-format :utf-8)
  (write-string "\"样本\"" out)
  :close-stream
  (han.json:read-json-file path))
;; => "样本"
```

[`parse-json-file`](parse-json-file.md) · [`get-json`](get-json.md) · [Source · 源码](../../../json/core.lisp#L384) · [Index · 索引](../README.md)
