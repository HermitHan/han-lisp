# `han.host:unsupported-host-function`

*Condition type · 条件类型*

## Syntax · 语法

```text
han.host:unsupported-host-function → condition type in fallback builds
```

## Description · 说明

The fallback backend defines this `error` subtype for operations such as `argv` or `run-program` that require a supported Lisp implementation. SBCL and LispWorks export the symbol but do not define the condition class. The example checks whether a defined class is an error subtype without calling an unsupported operation.

回退后端定义此 `error` 子类型，用于 `argv`、`run-program` 等依赖 Lisp 实现的操作。SBCL 和 LispWorks 导出该符号，但不定义条件类。示例在存在该类时检查它是否属于 error，不触发未支持操作。

## Examples · 示例

Inspect the exported symbol and, when its condition class is defined, check that it names an error type.

检查导出的符号，如果已定义对应的条件类，再确认它属于错误类型。

```lisp
(let ((name 'han.host:unsupported-host-function))
  (if (find-class name nil)
      (nth-value 0 (subtypep name 'error))
      (eq :external (nth-value 1 (find-symbol "UNSUPPORTED-HOST-FUNCTION" :han.host)))))
;; => T
```

Give a portable CLI an empty argument list on a host lacking the argv primitive, and propagate other errors.

让跨实现 CLI 在宿主缺少 argv 原语时使用空实参，其他错误仍传给调用方。

```lisp
(flet ((arguments ()
         (handler-case (han.host:argv)
           (error (condition)
             (let ((class (find-class 'han.host:unsupported-host-function nil)))
               (if (and class (typep condition class)) nil (error condition)))))))
  (listp (arguments)))
;; => T
```

[`han.host:*supported-implementations*`](var-supported-implementations.md) · [`han.host:argv`](argv.md) · [unsupported.lisp](../../../host/unsupported.lisp) · [Index · 索引](../README.md)
