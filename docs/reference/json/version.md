# `han.json:version`

[简体中文](version.zh-CN.md)

*Function*

## Syntax

```text
(han.json:version &optional (stream *standard-output*)) → version-string
```

## Description

Return the version string declared by the han.json package. The default stream prints a line with the package name and version. Pass `nil` for silent retrieval.

## Examples

Read the package version quietly for a programmatic check.

```lisp
(han.json:version nil)
;; => "0.3.0"
```

Capture the human-readable banner while retaining the version string separately.

```lisp
(let* ((out (make-string-output-stream))
       (version (han.json:version out))
       (banner (get-output-stream-string out)))
  (list version (with-input-from-string (in banner) (read-line in))))
;; => ("0.3.0" "han.json v0.3.0")
```

[`help`](help.md) · [Source](../../../json/package.lisp#L66) · [Index](../README.md)
