# `han.args:args-result`

[简体中文](args-result.zh-CN.md)

*Structure type*

## Syntax

```text
han.args:args-result
(typep object 'han.args:args-result) → generalized-boolean
```

## Description

The outcome of binding one parsed invocation against one command specification. Query it for values and inspect its diagnostics before running the command.

## Examples

Recognize the final stage of a successful invocation.

```lisp
(let ((result
        (han.args:bind-args
         (han.args:parse-args-spec (list (han.args:parse-arg-spec "(--/-j)jobs=1")))
         (han.args:parse-args-input '("demo" "-j" "4")))))
  (typep result 'han.args:args-result))
;; => t
```

Select the bound result from a pipeline trace and query it.

```lisp
(let* ((input (han.args:parse-args-input '("scan" "--jobs=4")))
       (spec (han.args:parse-args-spec (list (han.args:parse-arg-spec "(--)jobs"))))
       (trace (list input spec (han.args:bind-args spec input))))
  (han.args:get-arg "jobs" (find-if (lambda (x) (typep x 'han.args:args-result)) trace)))
;; => values ("4" :input)
```

[`han.args:args-result-p`](args-result-p.md) · [`han.args:make-args-result`](make-args-result.md) · [`han.args:bind-args`](bind-args.md) · [Source](../../../args/bind.lisp) · [Index](../README.md)
