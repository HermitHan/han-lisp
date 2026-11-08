# han.json · Read and write JSON

[User guide](README.md) · [简体中文](json.zh-CN.md) · [Package symbol index](../reference/README.md#json)

Use `han.json` to read a configuration document, inspect it as ordinary Lisp data and write an updated document. A parsed object is a hash table with case-sensitive string keys and the `equal` test. A parsed array is a vector. You can combine object lookups with Common Lisp sequence operations.

## Read a nested record

Suppose a configuration lists jobs. The first job has explicitly disabled retries and has left its timeout unset. You also want a default priority for jobs that omit that field.

```lisp
(let* ((config (han.json:parse-json
                "{\"jobs\":[{\"retry\":false,\"timeout\":null}]}"))
       (job (aref (han.json:get-json config "jobs") 0)))
  (list (multiple-value-list (han.json:get-json job "retry"))
        (multiple-value-list (han.json:get-json job "timeout"))
        (multiple-value-list (han.json:get-json job "priority" 3))))
;; => ((NIL T) (:NULL T) (3 NIL))
```

`get-json` reads one key at a time and returns the value and a presence flag. An existing key returns a true flag even if its value is `nil`. A missing key returns the supplied default (initially `nil`) and a false flag. Passing a non-object also returns the default and a false flag. When reading untrusted shapes, use `json-object-p`, `json-array-p` and a length check before indexing into a vector.

| JSON input | Lisp representation |
| --- | --- |
| Object, including `{}` | An `equal` hash table. A repeated key retains its last value. |
| Array, including `[]` | A vector, empty for `[]`. Use `aref` or `elt` with a zero-based index. |
| String | A Lisp string. Escapes are decoded, including paired Unicode surrogate escapes. |
| Number | A Lisp integer for whole-number literals. A decimal point or exponent selects a double float. |
| `true`, `false`, `null` | `t`, `nil`, `:null`, respectively. |

## Build and serialize a document

Give each object field as a cons whose `car` is a string and whose `cdr` is the whole value. The constructor also works with zero pairs. Use `(han.json:json-array)` for an empty array. An empty Lisp list is `nil` and encodes as `false`.

```lisp
(let ((job (han.json:json-object
            (cons "stages" (han.json:json-array "read" "index"))
            (cons "retry" nil))))
  (han.json:set-json job "timeout" :null)
  (han.json:encode-json job :indent nil))
;; => "{\"retry\":false,\"stages\":[\"read\",\"index\"],\"timeout\":null}"
```

Object keys are written in the host Lisp’s `string<` order; this is not a promise of a canonical byte sequence across implementations. The default `:indent 2` writes two spaces per nesting level and a final newline. Use `:indent nil` for a compact string with no final newline. The writer accepts integers and floats as numbers. Construct arrays from nonempty lists with `(coerce items 'vector)`. The encoder also accepts `:false` as input for JSON `false`.

## Character and number boundaries

A Unicode escape such as `\u6C49` becomes one Lisp character. Two escapes such as `\uD83D\uDE00` also become one character (U+1F600). An isolated surrogate or a scalar the host cannot map signals [`json-error`](../reference/json/json-error.md). When writing a string, Han escapes characters outside printable ASCII, so literal text and its equivalent Unicode escapes produce the same output. File functions select UTF-8; a stream passed to `write-json` keeps the encoding it was opened with.

Integer literals are exact. A decimal point or exponent selects the host’s `double-float`: some decimal values are rounded, and extreme exponents can signal an arithmetic condition. For example, use an integer count of cents if a price must remain exact. When writing, integers are always decimal; finite float spellings may differ between Lisp implementations. You do not need to bind Lisp printer variables.

## Public interface

Names below are exported by `han.json`.

| Read or construct | Behavior |
| --- | --- |
| [`(parse-json string)`](../reference/json/parse-json.md) | Parse one complete JSON value. Trailing whitespace is allowed. Malformed syntax, trailing commas or an extra value signal [`json-error`](../reference/json/json-error.md). |
| [`(parse-json-file path)`](../reference/json/parse-json-file.md), [`(read-json-file path)`](../reference/json/read-json-file.md) | Read a UTF-8 file in full and parse it. Both return the decoded value. File-system errors propagate separately. |
| [`(make-json-object &optional pairs)`](../reference/json/make-json-object.md) | Take a list of string-keyed cons pairs, e.g. `'(("count" . 2))`, and return a fresh object. |
| [`(json-object &rest pairs)`](../reference/json/json-object.md), [`(json-array &rest values)`](../reference/json/json-array.md) | Build a fresh object from individual pairs, or build a vector from individual values. |
| [`(json-object-p value)`](../reference/json/json-object-p.md), [`(json-array-p value)`](../reference/json/json-array-p.md), [`(json-null-p value)`](../reference/json/json-null-p.md) | Recognize a hash table, a non-string vector and the exact value `:null`, respectively. The first two are representation checks and do not validate the contents. |
| [`(json-keys object)`](../reference/json/json-keys.md) | Return the string keys sorted by `string<`. |
| [`(get-json object key &optional default)`](../reference/json/get-json.md) | Look up a string key. Return the value and the presence flag. |
| [`(set-json object key value)`](../reference/json/set-json.md) | Update the supplied hash table in place. Return the assigned value. |

| Output or diagnostics | Behavior |
| --- | --- |
| [`(encode-json value &key (indent 2))`](../reference/json/encode-json.md) | Return the JSON text as a string. |
| [`(write-json value stream &key (indent 2))`](../reference/json/write-json.md) | Write to a character output stream and return the input value. |
| [`(write-json-file path value &key (indent 2))`](../reference/json/write-json-file.md) | Create missing parent directories and write UTF-8, replacing an existing file. Return the supplied path. |
| `json-error` | Condition type for JSON syntax and unsupported values. Catch it with `handler-case` to report a malformed document. |
| [`(help &optional stream)`](../reference/json/help.md), [`(version &optional stream)`](../reference/json/version.md) | Return a help string or the package version string. Both also print to standard output by default. Pass `nil` to retrieve the string quietly. |

[Package exports](../../json/package.lisp) · [Implementation](../../json/core.lisp) · [Regression tests](../../json/test.lisp)
