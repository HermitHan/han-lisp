# `han.args:arg-segment-positions`

[简体中文](arg-segment-positions.zh-CN.md)

*Accessor*

## Syntax

```text
(han.args:arg-segment-positions segment) → list
(setf (han.args:arg-segment-positions segment) new-value) → new-value
```

## Description

Return the ordered token indices belonging to the segment. Each index addresses the full token vector, so slot switches still occupy an index there. An empty segment has an empty list.

## Examples

Find the two tokens sent to a named segment.

```lisp
(let ((segment
        (second (han.args:args-input-segments
                 (han.args:parse-args-input '("demo" "-v" "@filter:" "high" "low"))))))
  (han.args:arg-segment-positions segment))
;; => (2 3)
```

Preserve consecutive empty slots.

```lisp
(let ((input
        (han.args:parse-args-input '("demo" "@a:" "@b:" "z"))))
  (mapcar #'han.args:arg-segment-positions (han.args:args-input-segments input)))
;; => (nil nil (2))
```

[`han.args:arg-segment`](arg-segment.md) · [`han.args:parse-args-input`](parse-args-input.md) · [Source](../../../args/lexer.lisp) · [Index](../README.md)
