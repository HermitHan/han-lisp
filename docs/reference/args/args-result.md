# `han.args:args-result`

*Structure type · 结构类型*

## Syntax · 语法

```text
han.args:args-result
(typep object 'han.args:args-result) → generalized-boolean
```

## Description · 说明

The outcome of binding one parsed invocation against one command specification. Query it for values and inspect its diagnostics before running the command.

把一次调用的解析结果与命令规格绑定后得到的对象。执行命令前，可从中查询参数值并检查诊断。

## Examples · 示例

Recognize the final stage of a successful invocation. 确认成功绑定后得到的最终结果类型。

```lisp
(let ((result
        (han.args:bind-args
         (han.args:parse-args-spec (list (han.args:parse-arg-spec "(--/-j)jobs=1")))
         (han.args:parse-args-input '("demo" "-j" "4")))))
  (typep result 'han.args:args-result))
;; => t
```

Select the bound result from a pipeline trace and query it. 从解析流程记录中找到绑定结果，再查询实际参数。

```lisp
(let* ((input (han.args:parse-args-input '("scan" "--jobs=4")))
       (spec (han.args:parse-args-spec (list (han.args:parse-arg-spec "(--)jobs"))))
       (trace (list input spec (han.args:bind-args spec input))))
  (han.args:get-arg "jobs" (find-if (lambda (x) (typep x 'han.args:args-result)) trace)))
;; => values ("4" :input)
```

[`han.args:args-result-p`](args-result-p.md) · [`han.args:make-args-result`](make-args-result.md) · [`han.args:bind-args`](bind-args.md) · [Source · 源码](../../../args/bind.lisp) · [Index · 索引](../README.md)
