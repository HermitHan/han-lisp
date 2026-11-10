# `han.json:version`

[English](version.md)

*函数*

## 语法

```text
(han.json:version &optional (stream *standard-output*)) → version-string
```

## 说明

返回 han.json 包声明的版本字符串。默认还会向标准输出打印含包名与版本的一行文字。传入 `nil` 时只返回版本字符串。

## 示例

静默读取包版本，供程序检查。

```lisp
(han.json:version nil)
;; => "0.3.0"
```

捕获面向读者的版本提示行，同时保留可供程序处理的版本字符串。

```lisp
(let* ((out (make-string-output-stream))
       (version (han.json:version out))
       (banner (get-output-stream-string out)))
  (list version (with-input-from-string (in banner) (read-line in))))
;; => ("0.3.0" "han.json v0.3.0")
```

[`help`](help.zh-CN.md) · [源码](../../../json/package.lisp#L66) · [索引](../README.zh-CN.md)
