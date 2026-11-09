# `han.args:make-args-input`

[简体中文](make-args-input.zh-CN.md)

*Constructor*

## Syntax

```text
(han.args:make-args-input &key raw-cmd raw-argv tokens segments diagnostics) → han.args:args-input
```

## Description

Construct and return a fresh `args-input` with the supplied keyword fields. Omitted fields default to `nil`. For ordinary argv, the parser computes the token vector and segment indices together.

## Examples

Represent a call containing just the command name.

```lisp
(let ((input
        (han.args:make-args-input
         :raw-cmd "demo" :raw-argv nil :tokens #() :segments nil :diagnostics nil)))
  (han.args:args-input-raw-cmd input))
;; => "demo"
```

Bind a hand-built positional token using its segment index.

```lisp
(let* ((token (han.args:make-arg-token :kind :value :text "x" :value "x" :position 0))
       (segment (han.args:make-arg-segment :positions '(0)))
       (input (han.args:make-args-input :raw-cmd "demo" :raw-argv '("x")
                                        :tokens (vector token) :segments (list segment)))
       (schema (han.args:parse-args-spec (list (han.args:parse-arg-spec "$1")))))
  (han.args:get-arg 1 (han.args:bind-args schema input)))
;; => values ("x" :input)
```

[`han.args:args-input`](args-input.md) · [`han.args:args-input-raw-cmd`](args-input-raw-cmd.md) · [`han.args:parse-args-input`](parse-args-input.md) · [Source](../../../args/lexer.lisp) · [Index](../README.md)
