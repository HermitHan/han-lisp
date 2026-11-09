# `han.host:directory-files`

[简体中文](directory-files.zh-CN.md)

*Function*

## Syntax

```text
(han.host:directory-files directory) → list of pathnames
```

## Description

Lists the files immediately below `directory`. Enumeration combines native pathname patterns, removes duplicate entries and checks that a file belongs directly to the requested directory. An empty result is `nil`. If ordering matters, sort the returned list.

## Examples

Find the system definition named `han.asd` among the files in the checkout root.

```lisp
(let ((entries (han.host:directory-files (asdf:system-source-directory "han"))))
  (not (null (find "han.asd" entries :key #'file-namestring :test #'string=))))
;; => T
```

List the input files at one level while leaving the files in nested directories for a separate pass.

```lisp
(let ((root (uiop:ensure-directory-pathname (uiop:run-program '("mktemp" "-d") :output :line))))
  (unwind-protect
       (progn
         (han.host:append-utf8-line (han.path:join-path root "input.txt") "a")
         (han.host:append-utf8-line (han.path:join-path root "nested" "child.txt") "b")
         (mapcar #'file-namestring (han.host:directory-files root)))
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
         (sort (mapcar #'file-namestring (han.host:directory-files root)) #'string<))
    (uiop:delete-directory-tree root :validate t :if-does-not-exist :ignore)))
;; => ("a.dat" "b.dat")
```

[`han.host:subdirectories`](subdirectories.md) · [`han.host:file-exists-p`](file-exists-p.md) · [common.lisp](../../../host/common.lisp) · [Index](../README.md)
