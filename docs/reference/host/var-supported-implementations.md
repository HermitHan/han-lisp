# `han.host:*supported-implementations*`

*Special variable · 特殊变量*

## Syntax · 语法

```text
han.host:*supported-implementations* → list of implementation names
```

## Description · 说明

The initial value lists the implementation names recognized by Han. Use it for display or a capability hint. ASDF reader conditionals select the backend when the library loads, so rebinding this list does not install another adapter.

初始值列出 Han 支持的两种 Lisp 实现，可用于显示或提示。实际后端由 ASDF 装载时的读取器条件选择，重新绑定此变量不会安装另一套适配。

## Examples · 示例

Look for LispWorks among the supported implementation names.

在受支持的实现名称中查找 LispWorks。

```lisp
(member "LispWorks" han.host:*supported-implementations* :test #'string=)
;; => ("LispWorks")
```

Display the supported backend names in a diagnostic message.

在诊断消息中列出可用的宿主实现。

```lisp
(format nil "~{~A~^ / ~}" han.host:*supported-implementations*)
;; => "SBCL / LispWorks"
```

[`han.host:unsupported-host-function`](unsupported-host-function.md) · [`han.host:version`](version.md) · [parameters.lisp](../../../host/parameters.lisp) · [Index · 索引](../README.md)
