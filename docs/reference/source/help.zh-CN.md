# `han.source:help`

[English](help.md)

*函数*

## 语法

```text
(han.source:help &optional (stream *standard-output*)) → text
```

## 说明

返回包内置的帮助字符串。默认也将帮助写到标准输出；可以指定字符输出流，也可以传入 `nil` 只取字符串。

## 示例

**静默获取帮助文本并检查内容是否非空**

```lisp
(let ((text (han.source:help nil)))
  (and (stringp text) (plusp (length text))))
;; => T
```

**把返回的帮助文字同时写入指定流**

```lisp
(let ((stream (make-string-output-stream)))
  (let ((text (han.source:help stream)))
    (string= text (get-output-stream-string stream))))
;; => T
```

[`han.source:version`](version.zh-CN.md) · [源码](../../../source/package.lisp) · [索引](../README.zh-CN.md)
