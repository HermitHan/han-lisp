# `han.os:keep-read-line`

[English](keep-read-line.md)

*函数*

## 语法

```text
(han.os:keep-read-line &optional (stream *standard-input*) (limit nil)) → list of line strings
```

## 说明

按顺序读行并去掉行终止符。`nil` 表示读到 EOF，数值可限定行数，函数则能在每次读取前检查逆序的已读行。示例在取得标记行后停止，标记包含在第一份结果中，下一行留在原流。

## 示例

读到 `END` 标记行并保留该行，下一行留在流中。

```lisp
(with-input-from-string (input (format nil "one~%END~%three"))
  (list (han.os:keep-read-line input
                               (lambda (reversed)
                                 (not (equal (first reversed) "END"))))
        (read-line input)))
;; => (("one" "END") "three")
```

先读取表头，再完整保留后续数据中的空行。

```lisp
(with-input-from-string (in (format nil "column~%~%second~%"))
  (list (han.os:keep-read-line in 1) (han.os:keep-read-line in)))
;; => (("column") ("" "second"))
```

[`han.os:load-lines`](load-lines.zh-CN.md) · [`han.os:keep-read-char`](keep-read-char.zh-CN.md) · [io.lisp](../../../os/io.lisp) · [索引](../README.zh-CN.md)
