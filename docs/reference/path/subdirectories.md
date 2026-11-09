# `han.path:subdirectories`

[简体中文](subdirectories.zh-CN.md)

*Function*

## Syntax

```text
(han.path:subdirectories directory) → directory-pathnames
```

## Description

Lists the immediate child directories. Each result is a directory pathname suitable for another traversal. The function does not descend into those children. Results have no specified order.

## Examples

Find the `json` package directory among the immediate children of the Han source directory.

```lisp
(let* ((root (asdf:system-source-directory "han"))
       (children (han.path:subdirectories root)))
  (not (null (find "json" children :test #'string=
                   :key (lambda (entry) (car (last (pathname-directory entry))))))))
;; => T
```

Select only immediate child folders, ignoring files and grandchildren.

```lisp
(let ((root (uiop:ensure-directory-pathname (uiop:run-program '("mktemp" "-d") :output :line))))
  (unwind-protect
       (progn
         (han.host:append-utf8-line (han.path:join-path root "jobs" "done" "x") "")
         (han.host:append-utf8-line (han.path:join-path root "notes.txt") "")
         (mapcar (lambda (dir) (car (last (pathname-directory dir))))
                 (han.path:subdirectories root)))
    (uiop:delete-directory-tree root :validate t :if-does-not-exist :ignore)))
;; => ("jobs")
```

Detect a leaf directory after a file has been written to it.

```lisp
(let ((root (uiop:ensure-directory-pathname (uiop:run-program '("mktemp" "-d") :output :line))))
  (unwind-protect
       (progn
         (han.host:append-utf8-line (merge-pathnames "result.json" root) "{}")
         (if (han.path:subdirectories root) :branch :leaf))
    (uiop:delete-directory-tree root :validate t :if-does-not-exist :ignore)))
;; => :LEAF
```

[`han.path:directory-files`](directory-files.md) · [`han.path:directory-pathname`](directory-pathname.md) · [`han.host:subdirectories`](../host/subdirectories.md) · [Source](../../../path/core.lisp) · [Index](../README.md)
