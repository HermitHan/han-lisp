# `han.host:*supported-implementations*`

[简体中文](var-supported-implementations.zh-CN.md)

*Special variable*

## Syntax

```text
han.host:*supported-implementations* → list of implementation names
```

## Description

The initial value lists the names of the SBCL, LispWorks and ECL adapters. Use it for display or a capability hint. ASDF reader conditionals select the backend when the library loads, so rebinding this list does not install another adapter.

## Examples

Look for ECL among the supported implementation names.

```lisp
(find "ECL" han.host:*supported-implementations* :test #'string=)
;; => "ECL"
```

Display the supported backend names in a diagnostic message.

```lisp
(format nil "~{~A~^ / ~}" han.host:*supported-implementations*)
;; => "SBCL / LispWorks / ECL"
```

[`han.host:unsupported-host-function`](unsupported-host-function.md) · [`han.host:version`](version.md) · [parameters.lisp](../../../host/parameters.lisp) · [Index](../README.md)
