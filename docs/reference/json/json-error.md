# `han.json:json-error`

[简体中文](json-error.zh-CN.md)

*Condition type*

## Syntax

```text
han.json:json-error  <:  error
```

## Description

Handle this condition when parsing malformed JSON, constructing an object from an invalid pair or encoding a Lisp value that Han cannot represent. The condition prints a diagnostic message. File errors and floating-point arithmetic conditions are separate from `json-error`.

## Examples

Handle a malformed array at the point where the application reads it.

```lisp
(handler-case (han.json:parse-json "[1,]")
  (han.json:json-error () :invalid-json))
;; => :INVALID-JSON
```

The encoder signals the same condition when a record contains a ratio.

```lisp
(han.json:encode-json (han.json:json-object (cons "rate" 1/3)))
;; signals han.json:json-error
```

[`parse-json`](parse-json.md) · [`encode-json`](encode-json.md) · [Source](../../../json/core.lisp#L3) · [Index](../README.md)
