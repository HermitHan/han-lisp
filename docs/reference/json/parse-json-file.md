# `han.json:parse-json-file`

*Function · 函数*

## Syntax · 语法

```text
(han.json:parse-json-file path) → value
```

## Description · 说明

Open the pathname designator for character input with UTF-8 encoding, read its entire contents, then parse one JSON value. The input stream is closed on exit. Syntax errors signal `json-error`, while file access and decoding errors propagate. The example uses a temporary file managed by the UIOP included with ASDF.

按路径指示符打开 UTF-8 字符输入流，将文件完整读入后解析一个 JSON 值。退出时会关闭输入流。语法错误触发 `json-error`，文件访问或解码错误向外传递。示例由 ASDF 自带的 UIOP 管理临时文件。

## Examples · 示例

Read an array from a temporary file and index its last element.

从临时文件读取数组，再按下标访问末元素。

```lisp
(uiop:with-temporary-file (:stream out :pathname path :external-format :utf-8)
  (write-string "[3,5,8]" out)
  :close-stream
  (aref (han.json:parse-json-file path) 2))
;; => 8
```

Malformed syntax in an existing file reaches the same parser as a string.

文件可以正常打开时，非法语法仍由 JSON 解析器报告。

```lisp
(uiop:with-temporary-file (:stream out :pathname path :external-format :utf-8)
  (write-string "[1,]" out)
  :close-stream
  (han.json:parse-json-file path))
;; signals han.json:json-error
```

[`parse-json`](parse-json.md) · [`read-json-file`](read-json-file.md) · [`write-json-file`](write-json-file.md) · [Source · 源码](../../../json/core.lisp#L397) · [Index · 索引](../README.md)
