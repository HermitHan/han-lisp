# `han.host:*supported-implementations*`

[English](var-supported-implementations.md)

*特殊变量*

## 语法

```text
han.host:*supported-implementations* → list of implementation names
```

## 说明

初始值列出 SBCL、LispWorks 和 ECL 三个宿主实现，可用于显示或提示。实际后端由 ASDF 装载时的读取器条件选择，重新绑定此变量不会安装另一套适配。

## 示例

在受支持的实现名称中查找 ECL。

```lisp
(find "ECL" han.host:*supported-implementations* :test #'string=)
;; => "ECL"
```

在诊断消息中列出可用的宿主实现。

```lisp
(format nil "~{~A~^ / ~}" han.host:*supported-implementations*)
;; => "SBCL / LispWorks / ECL"
```

[`han.host:unsupported-host-function`](unsupported-host-function.zh-CN.md) · [`han.host:version`](version.zh-CN.md) · [parameters.lisp](../../../host/parameters.lisp) · [索引](../README.zh-CN.md)
