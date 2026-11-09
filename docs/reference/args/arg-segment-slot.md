# `han.args:arg-segment-slot`

[简体中文](arg-segment-slot.zh-CN.md)

*Accessor*

## Syntax

```text
(han.args:arg-segment-slot segment) → string or nil
(setf (han.args:arg-segment-slot segment) new-value) → new-value
```

## Description

Return the slot name without its surrounding `@` and `:`. A `nil` slot contains top-level arguments, including input after a switch back with `@:`.

## Examples

Read the name of the second segment.

```lisp
(let ((segment
        (second (han.args:args-input-segments
                 (han.args:parse-args-input '("demo" "-v" "@filter:" "high" "low"))))))
  (han.args:arg-segment-slot segment))
;; => "filter"
```

Return to the top level after a named slot.

```lisp
(let ((input
        (han.args:parse-args-input '("demo" "-v" "@files:" "a.txt" "@:" "z"))))
  (mapcar #'han.args:arg-segment-slot (han.args:args-input-segments input)))
;; => (nil "files" nil)
```

[`han.args:arg-segment`](arg-segment.md) · [`han.args:parse-args-input`](parse-args-input.md) · [Source](../../../args/lexer.lisp) · [Index](../README.md)
