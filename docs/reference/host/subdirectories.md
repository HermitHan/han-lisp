# `han.host:subdirectories`

[简体中文](subdirectories.zh-CN.md)

*Function*

## Syntax

```text
(han.host:subdirectories directory) → list of directory pathnames
```

## Description

Lists direct child directories of `directory` as pathnames. It does not recursively descend through their children. An empty result is `nil`. The example finds the host package in the loaded checkout without assuming a directory order.

## Examples

Find the `host/` module among the source directory’s immediate subdirectories.

```lisp
(let ((entries (han.host:subdirectories (asdf:system-source-directory "han"))))
  (not (null (find "host" entries :test #'string=
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
                 (han.host:subdirectories root)))
    (uiop:delete-directory-tree root :validate t :if-does-not-exist :ignore)))
;; => ("jobs")
```

Detect a leaf directory after a file has been written to it.

```lisp
(let ((root (uiop:ensure-directory-pathname (uiop:run-program '("mktemp" "-d") :output :line))))
  (unwind-protect
       (progn
         (han.host:append-utf8-line (merge-pathnames "result.json" root) "{}")
         (if (han.host:subdirectories root) :branch :leaf))
    (uiop:delete-directory-tree root :validate t :if-does-not-exist :ignore)))
;; => :LEAF
```

[`han.host:directory-files`](directory-files.md) · [`han.host:directory-exists-p`](directory-exists-p.md) · [common.lisp](../../../host/common.lisp) · [Index](../README.md)
