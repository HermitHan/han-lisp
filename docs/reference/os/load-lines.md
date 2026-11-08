# `han.os:load-lines`

*Function · 函数*

## Syntax · 语法

```text
(han.os:load-lines input) → list of line strings
```

## Description · 说明

Reads the remaining contents of a character stream, or opens a string filename or pathname using UTF-8. Returns lines in order without terminators. A supplied stream is left open. A missing file or an unsupported input designator signals an error.

可以从字符流的当前位置读取，也可传入字符串文件名或 pathname，以 UTF-8 打开文件。按顺序返回去掉行终止符的字符串列表，传入的流保持打开。文件缺失或参数类型不受支持时报错。

## Examples · 示例

Read a blank line between two lines of Chinese text and keep its place in the result.

读取两行中文之间的空行，结果列表用空字符串保留它的位置。

```lisp
(with-input-from-string (input (format nil "甲~%~%乙~%"))
  (han.os:load-lines input))
;; => ("甲" "" "乙")
```

Read a UTF-8 file produced by another writer. Adjacent newlines yield an empty row.

读取其他写入方生成的 UTF-8 文件，相邻换行产生空行。

```lisp
(uiop:with-temporary-file (:pathname file)
  (han.host:append-utf8-line file "数据")
  (han.host:append-utf8-line file "")
  (han.os:load-lines (namestring file)))
;; => ("数据" "")
```

Report a missing input file before running the parser.

在进入解析逻辑前报告缺失的输入文件。

```lisp
(uiop:with-temporary-file (:pathname file)
  (han.os:load-lines (han.path:join-path file "absent.txt")))
;; signals simple-error
```

[`han.os:load-string`](load-string.md) · [`han.os:keep-read-line`](keep-read-line.md) · [io.lisp](../../../os/io.lisp) · [Index · 索引](../README.md)
