# `han.source`

[User guide](README.md) · [简体中文](source.zh-CN.md) · [Package symbol index](../reference/README.md#source)

Use `han.source` to write a small lexer or parser over a string. A character source owns a moving cursor. A mark saves a location and a span identifies a range of text in that source. Your parser supplies the grammar, token types, and error policy.

## Read a setting and keep its field range

Read the field and integer in `port=80`, then consume a newline and record where the next line starts. Reset to the beginning and use the saved span to recover the exact field spelling.

```lisp
(let* ((src (han.source:make-char-source (format nil "port=80~%next")))
       (start (han.source:make-source-mark src))
       (name (han.source:source-read-while src #'alpha-char-p))
       (span (han.source:make-source-span start (han.source:make-source-mark src))))
  (assert (han.source:source-consume-char-if src #\=))
  (let ((value (parse-integer (han.source:source-read-while src #'digit-char-p))))
    (han.source:source-next-char src)
    (let ((next-line (multiple-value-list (han.source:source-location src))))
      (han.source:source-reset src start)
      (list name value next-line
            (han.source:source-slice-by-span src span)
            (han.source:source-peek-string src 4)))))
;; => ("port" 80 (8 2 1) "port" "port")
```

`(8 2 1)` means eight characters have been consumed and the next character is at line two, column one. Indices start at zero and lines and columns at one. Locations count Lisp characters. Reading `#\Newline` increments the line number and resets the column to one. Slicing and peeking leave the cursor in place.

## Try a delimiter

Try the longer delimiter `::` first. On mismatch you can still consume a single `:` from the same position. This is useful for punctuation with a shared prefix.

```lisp
(let ((src (han.source:make-char-source ":x")))
  (list (han.source:source-consume-string-if src "::")
        (han.source:source-peek-string src 3)
        (han.source:source-consume-char-if src #\:)
        (han.source:source-read-while src #'alpha-char-p)
        (han.source:source-eof-p src)))
;; => (NIL ":x" #\: "x" T)
```

The empty string matches at any position. When a loop uses `source-consume-string-if` to make progress, choose a nonempty delimiter. Each call to `make-char-source` creates a distinct origin, even for identical input text. Resetting requires a mark from that particular source.

## Exported API

The three exported structure types are `char-source`, `char-source-mark`, and `char-source-span`. Qualify the following functions with `han.source:`.

### Create and locate a cursor

| Function | Arguments | Behavior and return value |
| --- | --- | --- |
| [`make-char-source`](../reference/source/make-char-source.md) | `(string)` | Copy the input string and return a fresh [`char-source`](../reference/source/char-source.md) at `(0, 1, 1)`. |
| [`char-source-p`](../reference/source/char-source-p.md) | `(object)` | Recognize a character source. |
| [`char-source-string`](../reference/source/char-source-string.md) | `(src)` | Return the source's stored string. Treat it as read-only so that marks and coordinates continue to describe the same text. |
| [`char-source-length`](../reference/source/char-source-length.md) | `(src)` | Return the length of the source in characters. |
| [`source-location`](../reference/source/source-location.md) | `(source-or-mark)` | Return the character index, line and column as three values. Accepts a cursor or a saved mark. |
| [`source-eof-p`](../reference/source/source-eof-p.md) | `(src)` | True when the cursor has reached the end. |

### Look ahead and consume

| Function | Arguments | Behavior and return value |
| --- | --- | --- |
| [`source-peek-char`](../reference/source/source-peek-char.md) | `(src)` | Return the current character, or `nil` at EOF. Keeps the cursor in place. |
| [`source-peek-string`](../reference/source/source-peek-string.md) | `(src n)` | Return up to `n` characters from the cursor. Use a nonnegative count. At EOF the result is `""`. |
| [`source-match-char-p`](../reference/source/source-match-char-p.md) | `(src ch)` | Test an exact, case-sensitive character match at the cursor. |
| [`source-match-string-p`](../reference/source/source-match-string-p.md) | `(src target)` | Test an exact prefix at the cursor without advancing. The empty string matches even at EOF. |
| [`source-next-char`](../reference/source/source-next-char.md) | `(src)` | Return the current character and advance one. At EOF return `nil`. |
| [`source-consume-char-if`](../reference/source/source-consume-char-if.md) | `(src ch)` | On a match, advance one and return `ch`. On mismatch return `nil` at the original position. |
| [`source-consume-string-if`](../reference/source/source-consume-string-if.md) | `(src str)` | On a match, advance by the length of `str` and return it. On mismatch return `nil` at the original position. |
| [`source-advance-n`](../reference/source/source-advance-n.md) | `(src n)` | Move forward by up to `n` characters, stopping at EOF. Return `src`. |
| [`source-skip-while`](../reference/source/source-skip-while.md) | `(src predicate)` | Call `predicate` on each current character and advance while true. Return `src`. |
| [`source-read-while`](../reference/source/source-read-while.md) | `(src predicate)` | Consume the same run and return its characters as a string. If the first character fails, or at EOF, return `""`. |

### Keep marks and extract spans

| Function | Arguments | Behavior and return value |
| --- | --- | --- |
| [`make-source-mark`](../reference/source/make-source-mark.md) | `(src)` | Capture the origin and current location in a [`char-source-mark`](../reference/source/char-source-mark.md). The mark remains at that position as reading continues. |
| [`char-source-mark-p`](../reference/source/char-source-mark-p.md) | `(object)` | Recognize a saved mark. |
| [`source-reset`](../reference/source/source-reset.md) | `(src mark)` | Restore index, line and column from a mark of this source. Return `src`. |
| [`make-source-span`](../reference/source/make-source-span.md) | `(start end)` | Make a [`char-source-span`](../reference/source/char-source-span.md) between two marks of the same source. Equal positions form an empty span. An end before the start signals an error. |
| [`char-source-span-p`](../reference/source/char-source-span-p.md) | `(object)` | Recognize a span. |
| [`source-slice`](../reference/source/source-slice.md) | `(src start &optional end)` | Copy the half-open substring from `start` up to `end` (defaults to the cursor). Use valid nonnegative indices or marks from `src` for either boundary. |
| [`source-slice-by-span`](../reference/source/source-slice-by-span.md) | `(src span)` | Return the string covered by `span`. Signals an error when the span belongs to another source. |
| [`source-mark-from-source-p`](../reference/source/source-mark-from-source-p.md) | `(mark src &optional report-error)` | Test whether `mark` belongs to `src`. Passing a true `report-error` signals an error on mismatch. |
| [`source-span-from-source-p`](../reference/source/source-span-from-source-p.md) | `(span src &optional report-error)` | Test whether `span` belongs to `src`, with the same optional error behavior. |
| [`source-same-origin-p`](../reference/source/source-same-origin-p.md) | `(target &rest others)` | Compare the origin of any combination of cursors, marks and spans. Returns true if all have the same origin. |

### Package information

| Function | Arguments | Behavior and return value |
| --- | --- | --- |
| [`help`](../reference/source/help.md) | `(&optional stream)` | Return the help string and print it to `stream` (default `*standard-output*`). Pass `nil` for just the string. |
| [`version`](../reference/source/version.md) | `(&optional stream)` | Return the version string and print the package name and version by default. Pass `nil` to suppress printing. |

[Exports](../../source/package.lisp) · [Cursor and span implementation](../../source/char-source.lisp) · [Regression cases](../../source/test.lisp)
