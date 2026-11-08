# `han.json:write-json`

*Function · 函数*

## Syntax · 语法

```text
(han.json:write-json value stream &key (indent 2)) → value
```

## Description · 说明

Write JSON to the supplied character output stream and return the original Lisp value. The caller owns the stream. Pretty output ends in a newline. `:indent nil` writes compactly. An unsupported nested value can signal `json-error` after part of the document has already been written.

把 JSON 写入调用方提供的字符输出流，返回原来的 Lisp 值。流由调用方管理。带缩进的输出末尾有换行，`:indent nil` 写出紧凑文本。如果遇到不支持的嵌套值，会触发 `json-error`，此前的部分文本可能已经写入。

## Examples · 示例

Capture both the return value and the characters written to a stream.

分别取得函数返回值和实际写入流的字符。

```lisp
(let* ((out (make-string-output-stream))
       (value (han.json:write-json :null out :indent nil)))
  (list value (get-output-stream-string out)))
;; => (:NULL "null")
```

Build a JSON Lines stream by adding a newline after each compact value.

每次写入紧凑值后自行换行，就能得到 JSON Lines 流。

```lisp
(let ((text (with-output-to-string (out)
              (dolist (value '(t :null))
                (han.json:write-json value out :indent nil)
                (terpri out)))))
  (with-input-from-string (in text) (han.os:keep-read-line in)))
;; => ("true" "null")
```

[`encode-json`](encode-json.md) · [`write-json-file`](write-json-file.md) · [Source · 源码](../../../json/core.lisp#L488) · [Index · 索引](../README.md)
