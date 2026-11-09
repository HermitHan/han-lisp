# `han.args:args-input-segments`

[简体中文](args-input-segments.zh-CN.md)

*Accessor*

## Syntax

```text
(han.args:args-input-segments input) → list of arg-segment
(setf (han.args:args-input-segments input) new-value) → new-value
```

## Description

Return the ordered segments. The parser starts with a default segment and opens another at each slot switch. A segment may contain zero tokens.

## Examples

Locate the boundary between top-level arguments and a block.

```lisp
(let ((input (han.args:parse-args-input '("demo" "notes.txt" "@filter:" "--mode=fast"))))
  (mapcar #'han.args:arg-segment-slot (han.args:args-input-segments input)))
;; => (nil "filter")
```

Resolve the indices of the top-level and named arguments.

```lisp
(let ((input
        (han.args:parse-args-input '("demo" "z" "@stage:" "x" "y"))))
  (mapcar #'han.args:arg-segment-positions (han.args:args-input-segments input)))
;; => ((0) (2 3))
```

[`han.args:args-input`](args-input.md) · [`han.args:parse-args-input`](parse-args-input.md) · [Source](../../../args/lexer.lisp) · [Index](../README.md)
