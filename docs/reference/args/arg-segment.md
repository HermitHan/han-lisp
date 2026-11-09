# `han.args:arg-segment`

[简体中文](arg-segment.zh-CN.md)

*Structure type*

## Syntax

```text
han.args:arg-segment
(typep object 'han.args:arg-segment) → generalized-boolean
```

## Description

A group of token positions in one slot. The default slot holds top-level options and positionals. Named slots can bind whole blocks.

## Examples

Check the type of a named group returned by the lexer.

```lisp
(let ((segment
        (second (han.args:args-input-segments
                 (han.args:parse-args-input '("demo" "-v" "@filter:" "high" "low"))))))
  (typep segment 'han.args:arg-segment))
;; => t
```

Dispatch a top-level segment and a named block to different handlers.

```lisp
(let ((input (han.args:parse-args-input '("demo" "item" "@next:" "-q"))))
  (mapcar (lambda (item)
            (etypecase item
              (han.args:arg-segment
               (if (han.args:arg-segment-slot item) :delegate :parse-here))))
          (han.args:args-input-segments input)))
;; => (:parse-here :delegate)
```

[`han.args:arg-segment-p`](arg-segment-p.md) · [`han.args:make-arg-segment`](make-arg-segment.md) · [`han.args:parse-args-input`](parse-args-input.md) · [Source](../../../args/lexer.lisp) · [Index](../README.md)
