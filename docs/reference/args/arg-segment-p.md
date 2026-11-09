# `han.args:arg-segment-p`

[简体中文](arg-segment-p.zh-CN.md)

*Predicate*

## Syntax

```text
(han.args:arg-segment-p object) → generalized-boolean
```

## Description

Recognize a `arg-segment` structure. Any Lisp object can be passed. The predicate inspects its type without changing it.

## Examples

Recognize a named group returned by the lexer. Compare it with an unrelated keyword.

```lisp
(let ((segment
        (second (han.args:args-input-segments
                 (han.args:parse-args-input '("demo" "-v" "@filter:" "high" "low"))))))
  (list (han.args:arg-segment-p segment) (han.args:arg-segment-p :unparsed)))
;; => (t nil)
```

Read slot names from selected parse records.

```lisp
(let* ((input (han.args:parse-args-input '("demo" "@a:" "q")))
       (items (cons input (han.args:args-input-segments input))))
  (mapcar #'han.args:arg-segment-slot (remove-if-not #'han.args:arg-segment-p items)))
;; => (nil "a")
```

[`han.args:arg-segment`](arg-segment.md) · [`han.args:parse-args-input`](parse-args-input.md) · [Source](../../../args/lexer.lisp) · [Index](../README.md)
