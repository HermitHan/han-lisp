# `han.path:version`

[English](version.md)

*函数*

## 语法

```text
(han.path:version &optional (stream *standard-output*)) → version-string
```

## 说明

返回当前包的版本字符串。`stream` 非空时还会写出带包名的版本行。程序需要直接比较版本值时可以使用静默形式。

## 示例

静默取得路径包的版本字符串。

```lisp
(han.path:version nil)
;; => "0.3.0"
```

把格式化的包版本嵌入工具的诊断输出。

```lisp
(let ((output (with-output-to-string (stream)
                (han.path:version stream))))
  (string= output (format nil "han.path v~A~%" (han.path:version nil))))
;; => T
```

[`han.path:help`](help.zh-CN.md) · [源码](../../../path/package.lisp) · [索引](../README.zh-CN.md)
