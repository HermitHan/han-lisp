# `han.args:args-result-diagnostics`

*Accessor · 访问器*

## Syntax · 语法

```text
(han.args:args-result-diagnostics result) → list of arg-diagnostic
(setf (han.args:args-result-diagnostics result) new-value) → new-value
```

## Description · 说明

Return the collected lexer and binding diagnostics. Empty means that neither phase reported a warning or error for this result. Inspect each item's kind or code before using the bound values.

返回词法和绑定阶段收集到的诊断列表。空表表示本次处理的两个阶段均未报告警告或错误。可先检查诊断的类别或代码，再使用绑定值。

## Examples · 示例

Verify that a valid invocation has no diagnostics. 检查合法输入是否产生诊断。

```lisp
(let ((result
        (han.args:bind-args
         (han.args:parse-args-spec (list (han.args:parse-arg-spec "(--/-j)jobs=1")))
         (han.args:parse-args-input '("demo" "-j" "4")))))
  (han.args:args-result-diagnostics result))
;; => nil
```

Locate an option whose value was omitted. 单值选项出现却没有跟值时，诊断会指出其 argv 位置。

```lisp
(let ((result
        (han.args:bind-args
         (han.args:parse-args-spec
          (mapcar #'han.args:parse-arg-spec '("(--)name")))
         (han.args:parse-args-input '("demo" "--name")))))
  (let ((d (first (han.args:args-result-diagnostics result))))
    (values (han.args:arg-diagnostic-kind d)
            (han.args:arg-diagnostic-code d)
            (han.args:arg-diagnostic-position d))))
;; => values (:error :missing-option-value 0)
```

[`han.args:args-result`](args-result.md) · [`han.args:bind-args`](bind-args.md) · [Source · 源码](../../../args/bind.lisp) · [Index · 索引](../README.md)
