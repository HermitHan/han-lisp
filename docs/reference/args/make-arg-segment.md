# `han.args:make-arg-segment`

[简体中文](make-arg-segment.zh-CN.md)

*Constructor*

## Syntax

```text
(han.args:make-arg-segment &key slot positions) → han.args:arg-segment
```

## Description

Construct and return a fresh `arg-segment` with the supplied keyword fields. Omitted fields default to `nil`. When constructing one by hand, make sure the positions index into the corresponding input's token vector.

## Examples

Build a named segment for two token positions.

```lisp
(let ((segment
        (han.args:make-arg-segment
         :slot "filter" :positions '(2 3))))
  (han.args:arg-segment-slot segment))
;; => "filter"
```

Construct a top-level segment containing two indices.

```lisp
(let ((segment (han.args:make-arg-segment :positions '(0 1))))
  (values (han.args:arg-segment-slot segment) (han.args:arg-segment-positions segment)))
;; => values (nil (0 1))
```

[`han.args:arg-segment`](arg-segment.md) · [`han.args:arg-segment-slot`](arg-segment-slot.md) · [`han.args:parse-args-input`](parse-args-input.md) · [Source](../../../args/lexer.lisp) · [Index](../README.md)
