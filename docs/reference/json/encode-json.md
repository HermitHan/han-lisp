# `han.json:encode-json`

[简体中文](encode-json.zh-CN.md)

*Function*

## Syntax

```text
(han.json:encode-json value &key (indent 2)) → string
```

## Description

Return a JSON string. The writer sorts object keys by `string<` and uses two spaces per level and a trailing newline by default. `:indent nil` selects compact output without a trailing newline. Supply string-keyed objects, vectors, strings, integers, floats or the literals `t`, `nil`, `:false` and `:null`. Unsupported values such as ratios signal `json-error`. Integers always use decimal notation, independent of the caller’s printer base and radix. Finite floats use JSON number syntax; the precise spelling is implementation-dependent. Non-ASCII characters are escaped, with a surrogate pair for scalars above U+FFFF. Unmappable characters signal `json-error`.

## Examples

Produce compact output with predictable object-key order.

```lisp
(han.json:encode-json
 (han.json:json-object (cons "z" nil) (cons "a" (han.json:json-array 1 2)))
 :indent nil)
;; => "{\"a\":[1,2],\"z\":false}"
```

Capture the default pretty layout as separate lines, including the final line break.

```lisp
(let ((text (han.json:encode-json (han.json:json-array 2 3))))
  (list (with-input-from-string (in text) (han.os:keep-read-line in))
        (char= (char text (1- (length text))) #\Newline)))
;; => (("[" "  2," "  3" "]") T)
```

An empty vector, a false value and a null value remain distinct on the wire.

```lisp
(han.json:encode-json (han.json:json-array (han.json:json-array) nil :null)
                      :indent nil)
;; => "[[],false,null]"
```

Decimal integers keep their wire spelling when Lisp output is set to hexadecimal.

```lisp
(let ((*print-base* 16) (*print-radix* t))
  (han.json:encode-json 26 :indent nil))
;; => "26"
```

Encoding a ratio requires an application decision about how to represent it.

```lisp
(han.json:encode-json 1/3)
;; signals han.json:json-error
```

[`write-json`](write-json.md) · [`write-json-file`](write-json-file.md) · [Source](../../../json/core.lisp#L496) · [Index](../README.md)
