# `han.source:help`

*Function · 函数*

## Syntax · 语法

```text
(han.source:help &optional (stream *standard-output*)) → text
```

## Description · 说明

Returns the package’s built-in help text. By default it also writes that text to standard output. Supply a character output stream to capture it or `nil` to retrieve it silently.

返回包内置的帮助字符串。默认也将帮助写到标准输出；可以指定字符输出流，也可以传入 `nil` 只取字符串。

## Examples · 示例

**Retrieve the help text silently and check that it is nonempty · 静默获取帮助文本并检查内容是否非空**

```lisp
(let ((text (han.source:help nil)))
  (and (stringp text) (plusp (length text))))
;; => T
```

**Send the same text to a chosen stream · 把返回的帮助文字同时写入指定流**

```lisp
(let ((stream (make-string-output-stream)))
  (let ((text (han.source:help stream)))
    (string= text (get-output-stream-string stream))))
;; => T
```

[`han.source:version`](version.md) · [Source · 源码](../../../source/package.lisp) · [Index · 索引](../README.md)
