# `han.args:bind-args`

[简体中文](bind-args.zh-CN.md)

*Function*

## Syntax

```text
(han.args:bind-args args-spec args-input &optional builtin-table) → args-result
```

## Description

Bind a parsed command specification to a parsed invocation. The result retains both inputs and collects lexical warnings, binding errors, and values. Missing required arguments and duplicate single-value options produce diagnostics. If supplied, `builtin-table` must be a hash table of lookup keys to `arg-binding` records with statuses. If omitted, the result contains an empty built-in table.

## Examples

Inspect the result of omitting a required input.

```lisp
(let* ((specs (han.args:parse-args-spec
               (list (han.args:parse-arg-spec "!(--/-i)input"))))
       (result (han.args:bind-args specs (han.args:parse-args-input '("demo")))))
  (list (multiple-value-list (han.args:get-arg "input" result))
        (mapcar #'han.args:arg-diagnostic-code
                (han.args:args-result-diagnostics result))))
;; => ((nil :missing) (:missing-required))
```

Duplicate long and short spellings conflict for one single-value option.

```lisp
(let ((result
        (han.args:bind-args
         (han.args:parse-args-spec
          (mapcar #'han.args:parse-arg-spec '("(--/-n)name")))
         (han.args:parse-args-input '("demo" "--name=A" "-n" "B")))))
  (values (multiple-value-list (han.args:get-arg "name" result))
          (mapcar #'han.args:arg-diagnostic-code (han.args:args-result-diagnostics result))))
;; => values ((nil :conflict) (:conflict))
```

Pass a group of arguments through a named slot.

```lisp
(let ((result
        (han.args:bind-args
         (han.args:parse-args-spec
          (mapcar #'han.args:parse-arg-spec '("(@:)child")))
         (han.args:parse-args-input '("demo" "@child:" "--name" "")))))
  (mapcar #'han.args:arg-token-text (han.args:get-arg "child" result)))
;; => ("--name" "")
```

Use application context ahead of a declared default.

```lisp
(let ((builtins (make-hash-table :test 'equalp))
      (schema (han.args:parse-args-spec (list (han.args:parse-arg-spec "mode=local")))))
  (setf (gethash "mode" builtins)
        (han.args:make-arg-binding :name "mode" :value "cluster" :status :input))
  (han.args:get-arg "mode" (han.args:bind-args schema
                                              (han.args:parse-args-input '("demo")) builtins)))
;; => values ("cluster" :input)
```

[`han.args:get-arg`](get-arg.md) · [`han.args:args-result-diagnostics`](args-result-diagnostics.md) · [Source](../../../args/bind.lisp) · [Index](../README.md)
