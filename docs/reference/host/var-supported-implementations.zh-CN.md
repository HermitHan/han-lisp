# `han.host:*supported-implementations*`

[English](var-supported-implementations.md)

*特殊变量*

## 语法

```text
han.host:*supported-implementations* → list of implementation names
```

## 说明

初始值在各个安装环境中都列出 Han 提供的四种适配器，可用来显示库支持的实现。ASDF 在加载系统时选择当前使用的适配器。要查询某个子进程使用的后端，读取其句柄的 [`host-process-backend`](host-process-backend.zh-CN.md)。

## 示例

在受支持的实现名称中查找 ECL。

```lisp
(find "ECL" han.host:*supported-implementations* :test #'string=)
;; => "ECL"
```

在诊断消息中列出可用的宿主实现。

```lisp
(format nil "~{~A~^ / ~}" han.host:*supported-implementations*)
;; => "SBCL / LispWorks / ECL / CCL"
```

[`han.host:unsupported-host-function`](unsupported-host-function.zh-CN.md) · [`han.host:version`](version.zh-CN.md) · [parameters.lisp](../../../host/parameters.lisp) · [索引](../README.zh-CN.md)
