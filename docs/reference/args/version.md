# `han.args:version`

*Function · 函数*

## Syntax · 语法

```text
(han.args:version &optional (stream *standard-output*)) → string
```

## Description · 说明

Return the `han.args` version string. By default also print a line with the package name and its version. Pass an output stream to redirect that line, or `nil` to suppress printing.

返回 `han.args` 的版本字符串。默认同时输出一行包名和版本；可以传入输出流指定目的地，或传入 `nil` 只取返回值。

## Examples · 示例

Read the bare version string for use in another message. 取出纯版本字符串以便嵌入其他消息。

```lisp
(han.args:version nil)
;; => "0.1.0"
```

Inspect the formatted version line sent to a designated stream. 把面向用户的版本行写入指定流，并同时取得纯版本值。

```lisp
(let* ((stream (make-string-output-stream))
       (version (han.args:version stream)))
  (values version (string-right-trim '(#\Newline) (get-output-stream-string stream))))
;; => values ("0.1.0" "han.args v0.1.0")
```

[`han.args:help`](help.md) · [Source · 源码](../../../args/package.lisp) · [Index · 索引](../README.md)
