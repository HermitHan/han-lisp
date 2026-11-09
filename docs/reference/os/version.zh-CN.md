# `han.os:version`

[English](version.md)

*函数*

## 语法

```text
(han.os:version &optional (stream *standard-output*)) → version-string
```

## 说明

返回包的版本字符串。`stream` 非空时也向该流写入一行包含包名的版本信息，传 `nil` 则关闭打印。

## 示例

静默读取 OS 包的版本号，检查它是非空字符串。

```lisp
(let ((value (han.os:version nil)))
  (and (stringp value) (plusp (length value))))
;; => T
```

生成人可读的版本横幅，同时仍可取得仅含版本号的字符串。

```lisp
(let ((output (with-output-to-string (stream)
                (han.os:version stream))))
  (string= output (format nil "han.os v~A~%" (han.os:version nil))))
;; => T
```

[`han.os:help`](help.zh-CN.md) · [package.lisp](../../../os/package.lisp) · [索引](../README.zh-CN.md)
