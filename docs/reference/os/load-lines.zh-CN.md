# `han.os:load-lines`

[English](load-lines.md)

*函数*

## 语法

```text
(han.os:load-lines input) → list of line strings
```

## 说明

可以从字符流的当前位置读取，也可传入字符串文件名或 pathname，以 UTF-8 打开文件。按顺序返回去掉行终止符的字符串列表，传入的流保持打开。文件缺失或参数类型不受支持时报错。

## 示例

读取两行中文之间的空行，结果列表用空字符串保留它的位置。

```lisp
(with-input-from-string (input (format nil "甲~%~%乙~%"))
  (han.os:load-lines input))
;; => ("甲" "" "乙")
```

读取其他写入方生成的 UTF-8 文件，相邻换行产生空行。

```lisp
(uiop:with-temporary-file (:pathname file)
  (han.host:append-utf8-line file "数据")
  (han.host:append-utf8-line file "")
  (han.os:load-lines (namestring file)))
;; => ("数据" "")
```

在进入解析逻辑前报告缺失的输入文件。

```lisp
(uiop:with-temporary-file (:pathname file)
  (han.os:load-lines (han.path:join-path file "absent.txt")))
;; signals simple-error
```

[`han.os:load-string`](load-string.zh-CN.md) · [`han.os:keep-read-line`](keep-read-line.zh-CN.md) · [io.lisp](../../../os/io.lisp) · [索引](../README.zh-CN.md)
