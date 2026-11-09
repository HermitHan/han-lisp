# `han.os:load-string`

[English](load-string.md)

*函数*

## 语法

```text
(han.os:load-string input) → string
```

## 说明

参数与 `load-lines` 相同，可为字符流或 UTF-8 文件路径。相邻两行间用一个换行符连接，因此结果不区分最后一行有无终止换行。空输入返回空字符串。

## 示例

将两行读成一个字符串，检查行间与末尾的换行符分别如何处理。

```lisp
(with-input-from-string (input (format nil "a~%b~%"))
  (string= (han.os:load-string input) (format nil "a~%b")))
;; => T
```

将 UTF-8 文件中的多行拼成显示文本，保留中间的空行。

```lisp
(uiop:with-temporary-file (:pathname file)
  (dolist (line '("甲" "" "乙")) (han.host:append-utf8-line file line))
  (string= (han.os:load-string file) (format nil "甲~%~%乙")))
;; => T
```

解析器已消费首行时，只把流中剩下的正文收集为字符串。

```lisp
(with-input-from-string (in (format nil "version 1~%正文~%"))
  (read-line in)
  (han.os:load-string in))
;; => "正文"
```

[`han.os:load-lines`](load-lines.zh-CN.md) · [`han.os:keep-read-line`](keep-read-line.zh-CN.md) · [io.lisp](../../../os/io.lisp) · [索引](../README.zh-CN.md)
