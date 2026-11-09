# `han.args:args-result-p`

[简体中文](args-result-p.zh-CN.md)

*Predicate*

## Syntax

```text
(han.args:args-result-p object) → generalized-boolean
```

## Description

Recognize a `args-result` structure. Any Lisp object can be passed. The predicate inspects its type without changing it.

## Examples

Recognize the final stage of a successful invocation. Compare it with an unrelated keyword.

```lisp
(let ((result
        (han.args:bind-args
         (han.args:parse-args-spec (list (han.args:parse-arg-spec "(--/-j)jobs=1")))
         (han.args:parse-args-input '("demo" "-j" "4")))))
  (list (han.args:args-result-p result) (han.args:args-result-p :unparsed)))
;; => (t nil)
```

Query only the completed step of an invocation.

```lisp
(let* ((input (han.args:parse-args-input '("demo" "-v")))
       (spec (han.args:parse-args-spec (list (han.args:parse-arg-spec "(-v)verbose?"))))
       (done (han.args:bind-args spec input)))
  (mapcar (lambda (x)
            (if (han.args:args-result-p x) (han.args:get-arg "verbose" x) :pending))
          (list input done)))
;; => (:pending t)
```

[`han.args:args-result`](args-result.md) · [`han.args:bind-args`](bind-args.md) · [Source](../../../args/bind.lisp) · [Index](../README.md)
