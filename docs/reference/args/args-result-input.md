# `han.args:args-result-input`

[简体中文](args-result-input.zh-CN.md)

*Accessor*

## Syntax

```text
(han.args:args-result-input result) → args-input
(setf (han.args:args-result-input result) new-value) → new-value
```

## Description

Return the parsed invocation that was bound. Use it to recover the command, original argv, or token vector associated with a reported diagnostic.

## Examples

Recover the original argv of a completed binding.

```lisp
(let ((result
        (han.args:bind-args
         (han.args:parse-args-spec (list (han.args:parse-arg-spec "(--/-j)jobs=1")))
         (han.args:parse-args-input '("demo" "-j" "4")))))
  (han.args:args-input-raw-argv (han.args:args-result-input result)))
;; => ("-j" "4")
```

Use a diagnostic index to recover the offending argument.

```lisp
(let ((result
        (han.args:bind-args
         (han.args:parse-args-spec
          (mapcar #'han.args:parse-arg-spec '()))
         (han.args:parse-args-input '("demo" "--mystery")))))
  (let* ((d (first (han.args:args-result-diagnostics result)))
         (tokens (han.args:args-input-tokens (han.args:args-result-input result))))
    (han.args:arg-token-text (aref tokens (han.args:arg-diagnostic-position d)))))
;; => "--mystery"
```

[`han.args:args-result`](args-result.md) · [`han.args:bind-args`](bind-args.md) · [Source](../../../args/bind.lisp) · [Index](../README.md)
