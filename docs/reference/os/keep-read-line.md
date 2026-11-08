# `han.os:keep-read-line`

*Function · 函数*

## Syntax · 语法

```text
(han.os:keep-read-line &optional (stream *standard-input*) (limit nil)) → list of line strings
```

## Description · 说明

Reads lines in order and strips their line terminators. A `nil` limit reads to EOF, a count bounds the lines, and a function limit can inspect accumulated lines in reverse order before each read. In the example the marker is included in the first result and the following line remains in the stream.

按顺序读行并去掉行终止符。`nil` 表示读到 EOF，数值可限定行数，函数则能在每次读取前检查逆序的已读行。示例在取得标记行后停止，标记包含在第一份结果中，下一行留在原流。

## Examples · 示例

Read through the `END` marker and leave the following line in the stream.

读到 `END` 标记行并保留该行，下一行留在流中。

```lisp
(with-input-from-string (input (format nil "one~%END~%three"))
  (list (han.os:keep-read-line input
                               (lambda (reversed)
                                 (not (equal (first reversed) "END"))))
        (read-line input)))
;; => (("one" "END") "three")
```

Read a header and preserve a blank data row from the remaining stream.

先读取表头，再完整保留后续数据中的空行。

```lisp
(with-input-from-string (in (format nil "column~%~%second~%"))
  (list (han.os:keep-read-line in 1) (han.os:keep-read-line in)))
;; => (("column") ("" "second"))
```

[`han.os:load-lines`](load-lines.md) · [`han.os:keep-read-char`](keep-read-char.md) · [io.lisp](../../../os/io.lisp) · [Index · 索引](../README.md)
