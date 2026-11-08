# `han.os:load-string`

*Function · 函数*

## Syntax · 语法

```text
(han.os:load-string input) → string
```

## Description · 说明

Accepts the same character stream or UTF-8 filename as `load-lines`. Joins the resulting lines with a single newline between adjacent items. This loses the distinction between a final line ending and an unterminated last line. Empty input yields an empty string.

参数与 `load-lines` 相同，可为字符流或 UTF-8 文件路径。相邻两行间用一个换行符连接，因此结果不区分最后一行有无终止换行。空输入返回空字符串。

## Examples · 示例

Read two lines as one string and check which newline is retained.

将两行读成一个字符串，检查行间与末尾的换行符分别如何处理。

```lisp
(with-input-from-string (input (format nil "a~%b~%"))
  (string= (han.os:load-string input) (format nil "a~%b")))
;; => T
```

Combine UTF-8 file lines into display text and retain an empty middle line.

将 UTF-8 文件中的多行拼成显示文本，保留中间的空行。

```lisp
(uiop:with-temporary-file (:pathname file)
  (dolist (line '("甲" "" "乙")) (han.host:append-utf8-line file line))
  (string= (han.os:load-string file) (format nil "甲~%~%乙")))
;; => T
```

Use only the unread suffix when a parser has already consumed a stream header.

解析器已消费首行时，只把流中剩下的正文收集为字符串。

```lisp
(with-input-from-string (in (format nil "version 1~%正文~%"))
  (read-line in)
  (han.os:load-string in))
;; => "正文"
```

[`han.os:load-lines`](load-lines.md) · [`han.os:keep-read-line`](keep-read-line.md) · [io.lisp](../../../os/io.lisp) · [Index · 索引](../README.md)
