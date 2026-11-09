# `han.host:version`

[English](version.md)

*函数*

## 语法

```text
(han.host:version &optional (stream *standard-output*)) → version-string
```

## 说明

返回包的版本字符串。默认同时输出一行带包名的版本信息和换行。传 `nil` 关闭打印。

## 示例

静默读取版本号，确认返回值是字符串。

```lisp
(stringp (han.host:version nil))
;; => T
```

捕获带包名的版本行，组装命令的版本报告。

```lisp
(let ((output (with-output-to-string (stream)
                (han.host:version stream))))
  (string= output (format nil "han.host v~A~%" (han.host:version nil))))
;; => T
```

[`han.host:help`](help.zh-CN.md) · [package.lisp](../../../host/package.lisp) · [索引](../README.zh-CN.md)
