# `han.host:file-exists-p`

[简体中文](file-exists-p.zh-CN.md)

*Function*

## Syntax

```text
(han.host:file-exists-p path) → file pathname or nil
```

## Description

Accepts a filename string or pathname. Returns the probed pathname for an existing file. A directory or a failed probe yields `nil`. Use the returned pathname when opening the file.

## Examples

Look up a temporary file and check that its pathname is returned.

```lisp
(uiop:with-temporary-file (:pathname file)
  (pathnamep (han.host:file-exists-p file)))
;; => T
```

Treat a missing optional sidecar as absent before trying to read it.

```lisp
(let ((root (uiop:ensure-directory-pathname (uiop:run-program '("mktemp" "-d") :output :line))))
  (unwind-protect
       (han.host:file-exists-p (han.path:join-path root "report.meta"))
    (uiop:delete-directory-tree root :validate t :if-does-not-exist :ignore)))
;; => NIL
```

Use the returned pathname directly to open a verified input file.

```lisp
(uiop:with-temporary-file (:pathname input)
  (han.host:append-utf8-line input "sample-17")
  (let ((found (han.host:file-exists-p (namestring input))))
    (and found (with-open-file (stream found) (read-line stream)))))
;; => "sample-17"
```

[`han.host:directory-exists-p`](directory-exists-p.md) · [`han.path:file-exists-p`](../path/file-exists-p.md) · [common.lisp](../../../host/common.lisp) · [Index](../README.md)
