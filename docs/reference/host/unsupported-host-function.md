# `han.host:unsupported-host-function`

[简体中文](unsupported-host-function.zh-CN.md)

*Condition type*

## Syntax

```text
han.host:unsupported-host-function → condition type in fallback builds
```

## Description

The fallback backend defines this `error` subtype for operations such as `argv` or `run-program` that require a supported Lisp implementation. The SBCL, LispWorks and ECL adapters export the symbol without defining a condition class. Han selects the ECL adapter on macOS and Linux when ECL is built with Unicode. Other ECL builds use the fallback. The example checks whether a defined class is an error subtype without calling an unsupported operation.

## Examples

Inspect the exported symbol and, when its condition class is defined, check that it names an error type.

```lisp
(let ((name 'han.host:unsupported-host-function))
  (if (find-class name nil)
      (nth-value 0 (subtypep name 'error))
      (eq :external (nth-value 1 (find-symbol "UNSUPPORTED-HOST-FUNCTION" :han.host)))))
;; => T
```

Give a portable CLI an empty argument list on a host lacking the argv primitive, and propagate other errors.

```lisp
(flet ((arguments ()
         (handler-case (han.host:argv)
           (error (condition)
             (let ((class (find-class 'han.host:unsupported-host-function nil)))
               (if (and class (typep condition class)) nil (error condition)))))))
  (listp (arguments)))
;; => T
```

[`han.host:*supported-implementations*`](var-supported-implementations.md) · [`han.host:argv`](argv.md) · [unsupported.lisp](../../../host/unsupported.lisp) · [Index](../README.md)
