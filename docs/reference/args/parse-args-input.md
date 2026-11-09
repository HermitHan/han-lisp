# `han.args:parse-args-input`

[简体中文](parse-args-input.zh-CN.md)

*Function*

## Syntax

```text
(han.args:parse-args-input &optional (raw-input-args (han.host:argv t)) (add-cmd nil))
  → args-input
```

## Description

Lex a list of argument strings, optionally prepending the strings in `add-cmd`. The first combined item is the command. Each subsequent item receives a zero-based token position and belongs to a top-level or named segment. Omitting `raw-input-args` uses [the host argv](../host/argv.md). In an ECL script this includes interpreter options. To parse only application arguments after ECL’s `--`, pass that tail and supply your command name in `add-cmd`. Lexical warnings are stored on the returned input.

## Examples

Tokenize options supplied separately from the executable name.

```lisp
(let ((input (han.args:parse-args-input
              '("--jobs=4" "@filter:" "") '("report"))))
  (list (han.args:args-input-raw-cmd input)
        (mapcar #'han.args:arg-segment-slot (han.args:args-input-segments input))
        (han.args:arg-token-extra (aref (han.args:args-input-tokens input) 0))))
;; => ("report" (nil "filter") "4")
```

Retain a suspicious marker and its warning.

```lisp
(let ((input
        (han.args:parse-args-input '("demo" "--"))))
  (let ((token (aref (han.args:args-input-tokens input) 0))
        (warning (first (han.args:args-input-diagnostics input))))
    (values (han.args:arg-token-kind token)
            (han.args:arg-token-text token)
            (han.args:arg-diagnostic-position warning))))
;; => values (:value "--" 0)
```

Inspect a call containing only a command name.

```lisp
(let ((input
        (han.args:parse-args-input '("demo"))))
  (values (han.args:args-input-raw-cmd input)
          (length (han.args:args-input-tokens input))
          (mapcar #'han.args:arg-segment-slot (han.args:args-input-segments input))))
;; => values ("demo" 0 (nil))
```

[`han.args:args-input`](args-input.md) · [`han.args:parse-args-spec`](parse-args-spec.md) · [Source](../../../args/lexer.lisp) · [Index](../README.md)
