# `han.host:help`

[English](help.md)

*函数*

## 语法

```text
(han.host:help &optional (stream *standard-output*)) → text
```

## 说明

返回本包内置帮助字符串，默认同时将内容写到标准输出。传输出流可重定向，传 `nil` 只取得文本。

## 示例

静默取得帮助文本，在其中查找 `run-program-sync`。

```lisp
(let ((text (han.host:help nil)))
  (and (stringp text) (not (null (search "run-program-sync" text)))))
;; => T
```

将帮助写入调用方的流，以便在帮助面板中显示。

```lisp
(let ((text (han.host:help nil)))
  (string= text (with-output-to-string (destination)
                  (han.host:help destination))))
;; => T
```

[`han.host:version`](version.zh-CN.md) · [`han.host:run-program-sync`](run-program-sync.zh-CN.md) · [package.lisp](../../../host/package.lisp) · [索引](../README.zh-CN.md)
