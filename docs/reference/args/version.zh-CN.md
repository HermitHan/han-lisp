# `han.args:version`

[English](version.md)

*函数*

## 语法

```text
(han.args:version &optional (stream *standard-output*)) → string
```

## 说明

返回 `han.args` 的版本字符串。默认同时输出一行包名和版本；可以传入输出流指定目的地，或传入 `nil` 只取返回值。

## 示例

取出纯版本字符串以便嵌入其他消息。

```lisp
(han.args:version nil)
;; => "0.3.0"
```

把面向用户的版本行写入指定流，并同时取得纯版本值。

```lisp
(let* ((stream (make-string-output-stream))
       (version (han.args:version stream)))
  (values version (string-right-trim '(#\Newline) (get-output-stream-string stream))))
;; => values ("0.3.0" "han.args v0.3.0")
```

[`han.args:help`](help.zh-CN.md) · [源码](../../../args/package.lisp) · [索引](../README.zh-CN.md)
