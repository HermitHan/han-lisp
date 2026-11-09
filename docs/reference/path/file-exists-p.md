# `han.path:file-exists-p`

[简体中文](file-exists-p.zh-CN.md)

*Function*

## Syntax

```text
(han.path:file-exists-p path) → file-pathname-or-nil
```

## Description

Probes for an existing file and returns the pathname obtained by the host, otherwise `nil`. A directory does not satisfy the file test. The example locates the loaded system’s definition through ASDF.

## Examples

Probe the ASDF file and its containing directory with the same file predicate.

```lisp
(let ((definition (asdf:system-source-file "han")))
  (list (pathnamep (han.path:file-exists-p definition))
        (han.path:file-exists-p (han.path:parent-directory-pathname definition))))
;; => (T NIL)
```

Treat a missing optional sidecar as absent before trying to read it.

```lisp
(let ((root (uiop:ensure-directory-pathname (uiop:run-program '("mktemp" "-d") :output :line))))
  (unwind-protect
       (han.path:file-exists-p (han.path:join-path root "report.meta"))
    (uiop:delete-directory-tree root :validate t :if-does-not-exist :ignore)))
;; => NIL
```

Use the returned pathname directly to open a verified input file.

```lisp
(uiop:with-temporary-file (:pathname input)
  (han.host:append-utf8-line input "sample-17")
  (let ((found (han.path:file-exists-p (namestring input))))
    (and found (with-open-file (stream found) (read-line stream)))))
;; => "sample-17"
```

[`han.path:directory-exists-p`](directory-exists-p.md) · [`han.host:file-exists-p`](../host/file-exists-p.md) · [Source](../../../path/core.lisp) · [Index](../README.md)
