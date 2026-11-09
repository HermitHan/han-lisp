# `han.args:args-result-builtin-bindings`

[简体中文](args-result-builtin-bindings.zh-CN.md)

*Accessor*

## Syntax

```text
(han.args:args-result-builtin-bindings result) → hash table
(setf (han.args:args-result-builtin-bindings result) new-value) → new-value
```

## Description

Return the injected binding table checked first by `get-arg`. When the caller omits the third argument of `bind-args`, this is a fresh empty hash table.

## Examples

Inspect the default empty built-in table.

```lisp
(let ((result
        (han.args:bind-args
         (han.args:parse-args-spec (list (han.args:parse-arg-spec "(--/-j)jobs=1")))
         (han.args:parse-args-input '("demo" "-j" "4")))))
  (hash-table-count (han.args:args-result-builtin-bindings result)))
;; => 0
```

Retrieve the application-provided table and a contextual key.

```lisp
(let ((table (make-hash-table :test 'equalp)))
  (setf (gethash "site" table)
        (han.args:make-arg-binding :name "site" :value "local" :status :input))
  (let ((result (han.args:bind-args (han.args:parse-args-spec nil)
                                    (han.args:parse-args-input '("demo")) table)))
    (values (eq table (han.args:args-result-builtin-bindings result))
            (han.args:get-arg "SITE" result))))
;; => values (t "local")
```

[`han.args:args-result`](args-result.md) · [`han.args:bind-args`](bind-args.md) · [Source](../../../args/bind.lisp) · [Index](../README.md)
