# `han.args:args-result-bindings`

[简体中文](args-result-bindings.zh-CN.md)

*Accessor*

## Syntax

```text
(han.args:args-result-bindings result) → hash table
(setf (han.args:args-result-bindings result) new-value) → new-value
```

## Description

Return the `equalp` table of ordinary bindings, keyed by argument name or position. Inspect each `arg-binding` for the raw value, originating declaration, and binder status.

## Examples

Read a raw binding by its canonical name.

```lisp
(let ((result
        (han.args:bind-args
         (han.args:parse-args-spec (list (han.args:parse-arg-spec "(--/-j)jobs=1")))
         (han.args:parse-args-input '("demo" "-j" "4")))))
  (han.args:arg-binding-value (gethash "jobs" (han.args:args-result-bindings result))))
;; => "4"
```

Find the binding record of an absent flag.

```lisp
(let ((result
        (han.args:bind-args
         (han.args:parse-args-spec
          (mapcar #'han.args:parse-arg-spec '("(--)verbose?")))
         (han.args:parse-args-input '("demo")))))
  (multiple-value-bind (binding found-p)
      (gethash "verbose" (han.args:args-result-bindings result))
    (values found-p (han.args:arg-binding-status binding))))
;; => values (t :missing)
```

[`han.args:args-result`](args-result.md) · [`han.args:bind-args`](bind-args.md) · [Source](../../../args/bind.lisp) · [Index](../README.md)
