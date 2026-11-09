# `han.path:help`

[English](help.md)

*函数*

## 语法

```text
(han.path:help &optional (stream *standard-output*)) → text
```

## 说明

返回包内置的帮助字符串。默认也将帮助写到标准输出；可以指定字符输出流，也可以传入 `nil` 只取字符串。

## 示例

把包的帮助文本读入字符串，同时保持标准输出安静。

```lisp
(let ((text (han.path:help nil)))
  (and (stringp text) (plusp (length text))))
;; => T
```

把路径帮助直接写入可供编辑器显示的缓冲流。

```lisp
(let ((text (han.path:help nil)))
  (string= text (with-output-to-string (destination)
                  (han.path:help destination))))
;; => T
```

[`han.path:version`](version.zh-CN.md) · [源码](../../../path/package.lisp) · [索引](../README.zh-CN.md)
