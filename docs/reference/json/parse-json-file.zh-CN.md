# `han.json:parse-json-file`

[English](parse-json-file.md)

*函数*

## 语法

```text
(han.json:parse-json-file path) → value
```

## 说明

按路径指示符打开 UTF-8 字符输入流，将文件完整读入后解析一个 JSON 值。退出时会关闭输入流。语法错误触发 `json-error`。文件访问错误向外传递；非法 UTF-8 字节由宿主流的解码器处理。示例由 ASDF 自带的 UIOP 管理临时文件。

文件内容为 `22 F0 9F` 时，ECL 26.5.5 和 CCL 1.14 的 UTF-8 解码器读到 EOF，解析器随后因字符串未闭合而发出 `han.json:json-error`。SBCL 和 LispWorks 在读取这些字节时由解码器报错。对于 `22 C3 28 22`，CCL 返回只含一个 U+FFFD 替换字符的 JSON 字符串。[UTF-8 输入](../host/with-open-utf8-file.zh-CN.md)

## 示例

从临时文件读取数组，再按下标访问末元素。

```lisp
(uiop:with-temporary-file (:stream out :pathname path :external-format :utf-8)
  (write-string "[3,5,8]" out)
  :close-stream
  (aref (han.json:parse-json-file path) 2))
;; => 8
```

文件可以正常打开时，非法语法仍由 JSON 解析器报告。

```lisp
(uiop:with-temporary-file (:stream out :pathname path :external-format :utf-8)
  (write-string "[1,]" out)
  :close-stream
  (han.json:parse-json-file path))
;; signals han.json:json-error
```

[`parse-json`](parse-json.zh-CN.md) · [`read-json-file`](read-json-file.zh-CN.md) · [`write-json-file`](write-json-file.zh-CN.md) · [源码](../../../json/core.lisp#L381) · [索引](../README.zh-CN.md)
