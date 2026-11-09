# `han.args:args-result-diagnostics`

[English](args-result-diagnostics.md)

*访问器*

## 语法

```text
(han.args:args-result-diagnostics result) → list of arg-diagnostic
(setf (han.args:args-result-diagnostics result) new-value) → new-value
```

## 说明

返回词法和绑定阶段收集到的诊断列表。空表表示本次处理的两个阶段均未报告警告或错误。可先检查诊断的类别或代码，再使用绑定值。

## 示例

检查合法输入是否产生诊断。

```lisp
(let ((result
        (han.args:bind-args
         (han.args:parse-args-spec (list (han.args:parse-arg-spec "(--/-j)jobs=1")))
         (han.args:parse-args-input '("demo" "-j" "4")))))
  (han.args:args-result-diagnostics result))
;; => nil
```

单值选项出现却没有跟值时，诊断会指出其 argv 位置。

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

[`han.args:args-result`](args-result.zh-CN.md) · [`han.args:bind-args`](bind-args.zh-CN.md) · [源码](../../../args/bind.lisp) · [索引](../README.zh-CN.md)
