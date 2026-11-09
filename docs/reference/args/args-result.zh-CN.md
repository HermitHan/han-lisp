# `han.args:args-result`

[English](args-result.md)

*结构类型*

## 语法

```text
han.args:args-result
(typep object 'han.args:args-result) → generalized-boolean
```

## 说明

把一次调用的解析结果与命令规格绑定后得到的对象。执行命令前，可从中查询参数值并检查诊断。

## 示例

确认成功绑定后得到的最终结果类型。

```lisp
(let ((result
        (han.args:bind-args
         (han.args:parse-args-spec (list (han.args:parse-arg-spec "(--/-j)jobs=1")))
         (han.args:parse-args-input '("demo" "-j" "4")))))
  (typep result 'han.args:args-result))
;; => t
```

从解析流程记录中找到绑定结果，再查询实际参数。

```lisp
(let* ((input (han.args:parse-args-input '("scan" "--jobs=4")))
       (spec (han.args:parse-args-spec (list (han.args:parse-arg-spec "(--)jobs"))))
       (trace (list input spec (han.args:bind-args spec input))))
  (han.args:get-arg "jobs" (find-if (lambda (x) (typep x 'han.args:args-result)) trace)))
;; => values ("4" :input)
```

[`han.args:args-result-p`](args-result-p.zh-CN.md) · [`han.args:make-args-result`](make-args-result.zh-CN.md) · [`han.args:bind-args`](bind-args.zh-CN.md) · [源码](../../../args/bind.lisp) · [索引](../README.zh-CN.md)
