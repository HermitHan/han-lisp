# `han.host:*supported-implementations*`

[简体中文](var-supported-implementations.zh-CN.md)

*Special variable*

## Syntax

```text
han.host:*supported-implementations* → list of implementation names
```

## Description

The initial value lists the four adapters provided by Han on every installation. Use it to display the supported implementations. ASDF selects the active adapter when loading the system. To identify the backend of a running child, read its [`host-process-backend`](host-process-backend.md).

## Examples

Look for ECL among the supported implementation names.

```lisp
(find "ECL" han.host:*supported-implementations* :test #'string=)
;; => "ECL"
```

Display the supported backend names in a diagnostic message.

```lisp
(format nil "~{~A~^ / ~}" han.host:*supported-implementations*)
;; => "SBCL / LispWorks / ECL / CCL"
```

[`han.host:unsupported-host-function`](unsupported-host-function.md) · [`han.host:version`](version.md) · [parameters.lisp](../../../host/parameters.lisp) · [Index](../README.md)
