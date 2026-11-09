# `han.host:directory-exists-p`

[简体中文](directory-exists-p.zh-CN.md)

*Function*

## Syntax

```text
(han.host:directory-exists-p path) → directory pathname or nil
```

## Description

Accepts a string or pathname and coerces the final component to directory form. A successful directory probe returns a directory pathname. A missing directory or failed probe yields `nil`.

## Examples

Look up the Han source directory and check that the result is a pathname.

```lisp
(let ((dir (asdf:system-source-directory "han")))
  (pathnamep (han.host:directory-exists-p dir)))
;; => T
```

Reject a regular file supplied where an output directory is required.

```lisp
(uiop:with-temporary-file (:pathname file)
  (han.host:directory-exists-p file))
;; => NIL
```

Resolve a directory given without a trailing slash and use it to construct a child path.

```lisp
(let ((root (uiop:ensure-directory-pathname (uiop:run-program '("mktemp" "-d") :output :line))))
  (unwind-protect
       (let* ((spelling (string-right-trim "/" (namestring root)))
              (found (han.host:directory-exists-p spelling)))
         (string= (namestring (merge-pathnames "sample.tsv" found))
                  (namestring (merge-pathnames "sample.tsv" (truename root)))))
    (uiop:delete-directory-tree root :validate t :if-does-not-exist :ignore)))
;; => T
```

[`han.host:file-exists-p`](file-exists-p.md) · [`han.path:directory-pathname`](../path/directory-pathname.md) · [common.lisp](../../../host/common.lisp) · [Index](../README.md)
