# `han.test:version`

[简体中文](version.zh-CN.md)

*Function*

## Syntax

```text
(han.test:version &optional (stream *standard-output*)) → version-string
```

## Description

Return the version string declared by the han.test package. The default stream prints a line with the package name and version. Pass `nil` for silent retrieval.

## Examples

Read the package version quietly for a programmatic check.

```lisp
(han.test:version nil)
;; => "0.2.0"
```

Capture the human-readable banner while retaining the version string separately.

```lisp
(let* ((out (make-string-output-stream))
       (version (han.test:version out))
       (banner (get-output-stream-string out)))
  (list version (with-input-from-string (in banner) (read-line in))))
;; => ("0.2.0" "han.test v0.2.0")
```

[`help`](help.md) · [Source](../../../test/package.lisp#L53) · [Index](../README.md)
