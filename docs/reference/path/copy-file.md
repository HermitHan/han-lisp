# `han.path:copy-file`

[简体中文](copy-file.zh-CN.md)

*Function*

## Syntax

```text
(han.path:copy-file source target) → target
```

## Description

Copies bytes from an existing source into `target`, creating missing parent directories and replacing an existing target. Returns the original target argument. The operation can signal file errors. The example uses a temporary destination managed by UIOP.

## Examples

Copy the ASDF definition to a temporary file and compare the first lines.

```lisp
(uiop:with-temporary-file (:pathname target)
  (let ((source (asdf:system-source-file "han")))
    (han.path:copy-file source target)
    (with-open-file (copy target)
      (with-open-file (original source)
        (string= (read-line original) (read-line copy))))))
;; => T
```

Replace a longer destination with binary data, including a zero byte.

```lisp
(uiop:with-temporary-file (:pathname source)
  (uiop:with-temporary-file (:pathname target)
    (han.host:append-utf8-line target "longer old contents")
    (with-open-file (out source :direction :output :if-exists :supersede
                                :element-type '(unsigned-byte 8))
      (write-sequence #(0 255 13) out))
    (han.path:copy-file source target)
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
                (written (han.path:copy-file source target)))
           (han.os:load-lines written)))
    (uiop:delete-directory-tree root :validate t :if-does-not-exist :ignore)))
;; => ("exported")
```

[`han.path:file-exists-p`](file-exists-p.md) · [`han.host:copy-file`](../host/copy-file.md) · [Source](../../../path/core.lisp) · [Index](../README.md)
