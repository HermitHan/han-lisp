# `han.host:with-open-utf8-file`

[简体中文](with-open-utf8-file.zh-CN.md)

*Macro*

## Syntax

```text
(han.host:with-open-utf8-file (stream filespec &key direction if-exists if-does-not-exist)
  form*) → values of the body
```

## Description

Opens a UTF-8 character file and binds `stream` for the body. The default is input; creation, replacement, multiple return values and cleanup follow `with-open-file`. The external format and element type are fixed. If the Lisp cannot open a UTF-8 stream, the error propagates; Han does not retry using the machine’s default encoding. An existing caller-owned stream passed to `han.os:load-lines` is read directly instead.

Malformed input follows the host decoder. With bytes `22 F0 9F` (an opening quote and an incomplete character), ECL 26.5.5 reads the quote and then reaches EOF. The SBCL and LispWorks decoders signal a decoding error. With bytes `22 C3 28 22` all three decoders signal an error.

## Examples

Read the first line from this checkout’s UTF-8 README.

```lisp
(han.host:with-open-utf8-file (in (asdf:system-relative-pathname "han" "README.zh-CN.md"))
  (read-line in))
;; => "# Han Lisp"
```

Write text, then reopen the temporary file and read it back.

```lisp
(uiop:with-temporary-file (:pathname file)
  (han.host:with-open-utf8-file (out file :direction :output :if-exists :supersede)
    (write-string "汉😀" out))
  (han.host:with-open-utf8-file (in file)
    (values (read-line in) (read-char in nil :eof))))
;; => values ("汉😀" :EOF)
```

[`han.os:load-lines`](../os/load-lines.md) · [`han.json:write-json-file`](../json/write-json-file.md) · [Source](../../../host/common.lisp) · [Index](../README.md)
