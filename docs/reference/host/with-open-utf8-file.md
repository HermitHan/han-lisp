# `han.host:with-open-utf8-file`

*Macro · 宏*

## Syntax · 语法

```text
(han.host:with-open-utf8-file (stream filespec &key direction if-exists if-does-not-exist)
  form*) → values of the body
```

## Description · 说明

Opens a UTF-8 character file and binds `stream` for the body. The default is input; creation, replacement, multiple return values and cleanup follow `with-open-file`. The external format and element type are fixed. If the Lisp cannot open a UTF-8 stream, the error propagates; Han does not retry using the machine’s default encoding. An existing caller-owned stream passed to `han.os:load-lines` is read directly instead.

打开 UTF-8 文件，在宏体内将 `stream` 绑定到字符流。默认读取；文件的创建与替换、宏体的多个返回值、离开时关闭流的行为均遵循 `with-open-file`。编码和元素类型固定。宿主不能打开 UTF-8 流时，错误向外传递，不会悄悄改用本机默认编码。把自己打开的流传给 `han.os:load-lines` 时，它直接读该流，沿用原编码。

## Examples · 示例

Read the first line from this checkout’s UTF-8 README. 在本仓库中读取中文 README 的首行。

```lisp
(han.host:with-open-utf8-file (in (asdf:system-relative-pathname "han" "README.zh-CN.md"))
  (read-line in))
;; => "# Han Lisp"
```

Write text, then reopen the temporary file and read it back. 写出文本，关闭后重新打开同一临时文件验证结果。

```lisp
(uiop:with-temporary-file (:pathname file)
  (han.host:with-open-utf8-file (out file :direction :output :if-exists :supersede)
    (write-string "汉😀" out))
  (han.host:with-open-utf8-file (in file)
    (values (read-line in) (read-char in nil :eof))))
;; => values ("汉😀" :EOF)
```

[`han.os:load-lines`](../os/load-lines.md) · [`han.json:write-json-file`](../json/write-json-file.md) · [Source · 源码](../../../host/common.lisp) · [Index · 索引](../README.md)
