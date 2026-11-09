# `han.json:parse-json`

[简体中文](parse-json.zh-CN.md)

*Function*

## Syntax

```text
(han.json:parse-json string) → value
```

## Description

Parse one complete JSON value, allowing surrounding whitespace. Objects become `equal` hash tables with string keys, arrays become vectors and numbers become integers or, for decimal or exponent notation, double floats. The literals `true`, `false` and `null` map to `t`, `nil` and `:null`. Malformed input, trailing content and a non-string argument signal `json-error`. Escaped surrogate pairs decode to single characters; an isolated surrogate or a character the host cannot map signals `json-error`. Fractional values may round. A syntactically valid number outside the floating-point range can signal an arithmetic condition.

## Examples

Read a heterogeneous array as Lisp scalar values.

```lisp
(coerce (han.json:parse-json "[2,true,false,null]") 'list)
;; => (2 T NIL :NULL)
```

An exponent in the input selects a double-float result.

```lisp
(han.json:parse-json "1.25e2")
;; => 125.0d0
```

Decode Unicode escape sequences in a quoted JSON string.

```lisp
(han.json:parse-json "\"\\u4F60\\u597D\"")
;; => "你好"
```

Reject two top-level values in one document.

```lisp
(han.json:parse-json "true false")
;; signals han.json:json-error
```

[`parse-json-file`](parse-json-file.md) · [`encode-json`](encode-json.md) · [`json-error`](json-error.md) · [Source](../../../json/core.lisp#L357) · [Index](../README.md)
