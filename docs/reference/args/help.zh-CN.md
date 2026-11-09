# `han.args:help`

[English](help.md)

*函数*

## 语法

```text
(han.args:help &optional (stream *standard-output*)) → string
```

## 说明

返回包内帮助文字，涵盖规格、输入解析、绑定和查询。`stream` 非空时也向该流写出这段文字；希望直接使用返回的字符串时可传 `nil`。

## 示例

直接搜索帮助文本，同时保持当前输出流安静。

```lisp
(let ((text (han.args:help nil)))
  (not (null (search "parse-args-input" text))))
;; => t
```

捕获写给指定流的帮助，并和返回的字符串核对。

```lisp
(let* ((stream (make-string-output-stream))
       (text (han.args:help stream)))
  (string= text (get-output-stream-string stream)))
;; => t
```

[`han.args:version`](version.zh-CN.md) · [`han.args:parse-args-input`](parse-args-input.zh-CN.md) · [源码](../../../args/package.lisp) · [索引](../README.zh-CN.md)
