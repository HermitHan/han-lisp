# `han.host:with-open-utf8-file`

[English](with-open-utf8-file.md)

*宏*

## 语法

```text
(han.host:with-open-utf8-file (stream filespec &key direction if-exists if-does-not-exist)
  form*) → values of the body
```

## 说明

打开 UTF-8 文件，在宏体内将 `stream` 绑定到字符流。默认读取；文件的创建与替换、宏体的多个返回值、离开时关闭流的行为均遵循 `with-open-file`。编码和元素类型固定。宿主不能打开 UTF-8 流时，错误向外传递，不会悄悄改用本机默认编码。把自己打开的流传给 `han.os:load-lines` 时，它直接读该流，沿用原编码。

非法字节由宿主解码器处理。对于 `22 F0 9F`（起始引号后接不完整字符），ECL 26.5.5 和 CCL 1.14 读到引号后遇到 EOF，SBCL 和 LispWorks 发出解码错误。对于含非法续字节的 `22 C3 28 22`，CCL 依次读到引号、一个 U+FFFD 替换字符和结束引号。SBCL、LispWorks 和 ECL 对这组字节发出解码错误。

## 示例

在本仓库中读取中文 README 的首行。

```lisp
(han.host:with-open-utf8-file (in (asdf:system-relative-pathname "han" "README.zh-CN.md"))
  (read-line in))
;; => "# Han Lisp"
```

写出文本，关闭后重新打开同一临时文件验证结果。

```lisp
(uiop:with-temporary-file (:pathname file)
  (han.host:with-open-utf8-file (out file :direction :output :if-exists :supersede)
    (write-string "汉😀" out))
  (han.host:with-open-utf8-file (in file)
    (values (read-line in) (read-char in nil :eof))))
;; => values ("汉😀" :EOF)
```

[`han.os:load-lines`](../os/load-lines.zh-CN.md) · [`han.json:write-json-file`](../json/write-json-file.zh-CN.md) · [源码](../../../host/common.lisp) · [索引](../README.zh-CN.md)
