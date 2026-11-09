# `han.source:version`

[English](version.md)

*函数*

## 语法

```text
(han.source:version &optional (stream *standard-output*)) → version-string
```

## 说明

返回当前包的版本字符串。`stream` 非空时还会写出带包名的版本行。程序需要直接比较版本值时可以使用静默形式。

## 示例

**静默读取包的版本字符串**

```lisp
(han.source:version nil)
;; => "0.2.0"
```

**同时取得版本值及写到流中的版本行**

```lisp
(let ((out (make-string-output-stream)))
  (let ((number (han.source:version out)))
    (string= (get-output-stream-string out)
             (format nil "han.source v~A~%" number))))
;; => T
```

[`han.source:help`](help.zh-CN.md) · [源码](../../../source/package.lisp) · [索引](../README.zh-CN.md)
