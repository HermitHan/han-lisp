# `han.host:unsupported-host-function`

[English](unsupported-host-function.md)

*条件类型*

## 语法

```text
han.host:unsupported-host-function → condition type in fallback builds
```

## 说明

回退后端定义此 `error` 子类型，用于 `argv`、`run-program` 等依赖 Lisp 实现的操作。SBCL、LispWorks、ECL 和 CCL 的适配器都导出此符号，符号没有对应的条件类。ECL 适配器用于 macOS 和 Linux 上开启 Unicode 的 ECL，CCL 适配器用于 64 位 Darwin 和 Linux。其他 ECL 和 CCL 目标使用回退后端。示例在存在该类时检查它是否属于 error，不触发未支持操作。

## 示例

检查导出的符号，如果已定义对应的条件类，再确认它属于错误类型。

```lisp
(let ((name 'han.host:unsupported-host-function))
  (if (find-class name nil)
      (nth-value 0 (subtypep name 'error))
      (eq :external (nth-value 1 (find-symbol "UNSUPPORTED-HOST-FUNCTION" :han.host)))))
;; => T
```

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

[`han.host:*supported-implementations*`](var-supported-implementations.zh-CN.md) · [`han.host:argv`](argv.zh-CN.md) · [unsupported.lisp](../../../host/unsupported.lisp) · [索引](../README.zh-CN.md)
