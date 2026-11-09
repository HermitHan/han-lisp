# `han.args:args-input`

[简体中文](args-input.zh-CN.md)

*Structure type*

## Syntax

```text
han.args:args-input
(typep object 'han.args:args-input) → generalized-boolean
```

## Description

Lexical analysis of one invocation. It keeps the command separate from argv and links token indices to slot segments. This stage can report ambiguous token spellings before an argument specification exists.

## Examples

Recognize the object representing a complete invocation.

```lisp
(let ((input (han.args:parse-args-input '("demo" "notes.txt" "@filter:" "--mode=fast"))))
  (typep input 'han.args:args-input))
;; => t
```

Let a caller pass either an argv list or an already parsed invocation.

```lisp
(flet ((command-of (x)
         (etypecase x
           (han.args:args-input (han.args:args-input-raw-cmd x))
           (list (han.args:args-input-raw-cmd (han.args:parse-args-input x))))))
  (list (command-of '("list")) (command-of (han.args:parse-args-input '("show")))))
;; => ("list" "show")
```

[`han.args:args-input-p`](args-input-p.md) · [`han.args:make-args-input`](make-args-input.md) · [`han.args:parse-args-input`](parse-args-input.md) · [Source](../../../args/lexer.lisp) · [Index](../README.md)
