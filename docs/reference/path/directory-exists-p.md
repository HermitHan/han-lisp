# `han.path:directory-exists-p`

[简体中文](directory-exists-p.zh-CN.md)

*Function*

## Syntax

```text
(han.path:directory-exists-p path) → directory-pathname-or-nil
```

## Description

Probes the input as a directory and returns a directory pathname on success, otherwise `nil`. Use the returned pathname as a base for subsequent lookups.

## Examples

Look up the Han source directory and check that the result is a directory pathname.

```lisp
(let ((root (asdf:system-source-directory "han")))
  (han.path:directory-pathname-p (han.path:directory-exists-p root)))
;; => T
```

Reject a regular file supplied where an output directory is required.

```lisp
(uiop:with-temporary-file (:pathname file)
  (han.path:directory-exists-p file))
;; => NIL
```

Resolve a directory given without a trailing slash and use it to construct a child path.

```lisp
(let ((root (uiop:ensure-directory-pathname (uiop:run-program '("mktemp" "-d") :output :line))))
  (unwind-protect
       (let* ((spelling (string-right-trim "/" (namestring root)))
              (found (han.path:directory-exists-p spelling)))
         (string= (namestring (merge-pathnames "sample.tsv" found))
                  (namestring (merge-pathnames "sample.tsv" (truename root)))))
    (uiop:delete-directory-tree root :validate t :if-does-not-exist :ignore)))
;; => T
```

[`han.path:directory-pathname-p`](directory-pathname-p.md) · [`han.path:directory-files`](directory-files.md) · [`han.host:directory-exists-p`](../host/directory-exists-p.md) · [Source](../../../path/core.lisp) · [Index](../README.md)
