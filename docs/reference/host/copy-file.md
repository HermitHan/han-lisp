# `han.host:copy-file`

[简体中文](copy-file.zh-CN.md)

*Function*

## Syntax

```text
(han.host:copy-file source target) → target
```

## Description

Copies the bytes of the source file, creating parent directories as needed and replacing any existing target contents. Returns the original target argument. File errors propagate. Choose distinct paths for the source and destination. The example creates two temporary files.

Use [`atomic-replace-file`](atomic-replace-file.md) to publish a finished file under its final name in a single step.

## Examples

Copy a file containing one line and read the line from the destination.

```lisp
(uiop:with-temporary-file (:pathname source)
  (uiop:with-temporary-file (:pathname target)
    (han.host:append-utf8-line source "copied")
    (han.host:copy-file source target)
    (han.os:load-lines target)))
;; => ("copied")
```

Replace a longer destination with binary data, including a zero byte.

```lisp
(uiop:with-temporary-file (:pathname source)
  (uiop:with-temporary-file (:pathname target)
    (han.host:append-utf8-line target "longer old contents")
    (with-open-file (out source :direction :output :if-exists :supersede
                                :element-type '(unsigned-byte 8))
      (write-sequence #(0 255 13) out))
    (han.host:copy-file source target)
    (with-open-file (in target :element-type '(unsigned-byte 8))
      (list (file-length in) (read-byte in) (read-byte in) (read-byte in)))))
;; => (3 0 255 13)
```

Copy into a new nested directory and reuse the returned target path.

```lisp
(let ((root (uiop:ensure-directory-pathname (uiop:run-program '("mktemp" "-d") :output :line))))
  (unwind-protect
       (uiop:with-temporary-file (:pathname source)
         (han.host:append-utf8-line source "exported")
         (let* ((target (han.path:join-path root "archive" "day1" "copy.tsv"))
                (written (han.host:copy-file source target)))
           (han.os:load-lines written)))
    (uiop:delete-directory-tree root :validate t :if-does-not-exist :ignore)))
;; => ("exported")
```

[`han.host:file-exists-p`](file-exists-p.md) · [`han.path:copy-file`](../path/copy-file.md) · [common.lisp](../../../host/common.lisp) · [Index](../README.md)
