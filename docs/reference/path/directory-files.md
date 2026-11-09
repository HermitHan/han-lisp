# `han.path:directory-files`

[简体中文](directory-files.zh-CN.md)

*Function*

## Syntax

```text
(han.path:directory-files directory) → file-pathnames
```

## Description

Returns a list of direct file children. Nested files and directories are omitted. An empty list can also result from a failed directory probe. Sort a copy before relying on any particular traversal order.

## Examples

Find `han.asd` among the files listed in the Han source directory.

```lisp
(let ((files (han.path:directory-files (asdf:system-source-directory "han"))))
  (and (find "han.asd" files :key #'file-namestring :test #'string=) t))
;; => T
```

List the input files at one level while leaving the files in nested directories for a separate pass.

```lisp
(let ((root (uiop:ensure-directory-pathname (uiop:run-program '("mktemp" "-d") :output :line))))
  (unwind-protect
       (progn
         (han.host:append-utf8-line (han.path:join-path root "input.txt") "a")
         (han.host:append-utf8-line (han.path:join-path root "nested" "child.txt") "b")
         (mapcar #'file-namestring (han.path:directory-files root)))
    (uiop:delete-directory-tree root :validate t :if-does-not-exist :ignore)))
;; => ("input.txt")
```

Build a stable import order for files created in a different order.

```lisp
(let ((root (uiop:ensure-directory-pathname (uiop:run-program '("mktemp" "-d") :output :line))))
  (unwind-protect
       (progn
         (dolist (name '("b.dat" "a.dat"))
           (han.host:append-utf8-line (merge-pathnames name root) "entry"))
         (sort (mapcar #'file-namestring (han.path:directory-files root)) #'string<))
    (uiop:delete-directory-tree root :validate t :if-does-not-exist :ignore)))
;; => ("a.dat" "b.dat")
```

[`han.path:subdirectories`](subdirectories.md) · [`han.path:directory-exists-p`](directory-exists-p.md) · [`han.host:directory-files`](../host/directory-files.md) · [Source](../../../path/core.lisp) · [Index](../README.md)
