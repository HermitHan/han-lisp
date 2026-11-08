# `han.args:help`

*Function · 函数*

## Syntax · 语法

```text
(han.args:help &optional (stream *standard-output*)) → string
```

## Description · 说明

Return the package's built-in help text covering specifications, input parsing, binding, and lookup. When `stream` is non-nil, write the same text there. Pass `nil` to use the returned string without printing.

返回包内帮助文字，涵盖规格、输入解析、绑定和查询。`stream` 非空时也向该流写出这段文字；希望直接使用返回的字符串时可传 `nil`。

## Examples · 示例

Search the built-in help without printing it. 直接搜索帮助文本，同时保持当前输出流安静。

```lisp
(let ((text (han.args:help nil)))
  (not (null (search "parse-args-input" text))))
;; => t
```

Capture the printed help and compare it with the returned text. 捕获写给指定流的帮助，并和返回的字符串核对。

```lisp
(let* ((stream (make-string-output-stream))
       (text (han.args:help stream)))
  (string= text (get-output-stream-string stream)))
;; => t
```

[`han.args:version`](version.md) · [`han.args:parse-args-input`](parse-args-input.md) · [Source · 源码](../../../args/package.lisp) · [Index · 索引](../README.md)
