# `han.json:read-json-file`

[English](read-json-file.md)

*函数*

## 语法

```text
(han.json:read-json-file path) → value
```

## 说明

读取并解析 UTF-8 JSON 文档，行为与返回值同 `parse-json-file`。顶层可以是任何 JSON 值，包括数组和标量。非法 UTF-8 字节由宿主流的解码器处理。成功解码后的 JSON 语法错误触发 `json-error`，打开不存在的文件会发出文件错误。

## 示例

从文件读取显式空值，并保留字段存在标志。

```lisp
(uiop:with-temporary-file (:stream out :pathname path :external-format :utf-8)
  (write-string "{\"timeout\":null}" out)
  :close-stream
  (multiple-value-list (han.json:get-json (han.json:read-json-file path) "timeout")))
;; => (:NULL T)
```

整个文件可以只包含一个 Unicode 字符串。

```lisp
(uiop:with-temporary-file (:stream out :pathname path :external-format :utf-8)
  (write-string "\"样本\"" out)
  :close-stream
  (han.json:read-json-file path))
;; => "样本"
```

[`parse-json-file`](parse-json-file.zh-CN.md) · [`get-json`](get-json.zh-CN.md) · [源码](../../../json/core.lisp#L384) · [索引](../README.zh-CN.md)
