# `han.json:help`

*Function · 函数*

## Syntax · 语法

```text
(han.json:help &optional (stream *standard-output*)) → text
```

## Description · 说明

Return the package’s built-in help string with the JSON data model, construction and encoding examples. With the default stream the same text is printed to standard output. Pass `nil` to retrieve the string silently.

返回包内置的帮助字符串，含 JSON 的数据表示、构造与编码示例。默认同时打印到标准输出。传入 `nil` 时只取回文本。

## Examples · 示例

Search the returned help text without writing to standard output.

静默获取帮助文本，并检查其中是否有需要的接口名。

```lisp
(let ((text (han.json:help nil)))
  (and (stringp text) (not (null (search "get-json" text)))))
;; => T
```

Route the help to a caller-owned stream and compare the captured text with the return value.

将帮助发往调用方的流，并核对流中收到的文本与函数返回值。

```lisp
(let ((out (make-string-output-stream)))
  (let ((text (han.json:help out)))
    (string= text (get-output-stream-string out))))
;; => T
```

[`version`](version.md) · [Source · 源码](../../../json/package.lisp#L60) · [Index · 索引](../README.md)
