# `han.host:cwd`

[简体中文](cwd.zh-CN.md)

*Function*

## Syntax

```text
(han.host:cwd) → namestring or nil
```

## Description

Returns the namestring of the resolved working directory, or `nil` if resolution fails. This returns a value suitable for display or for conversion to a pathname.

## Examples

If a working directory is available, use its name to look up the directory.

```lisp
(let ((dir (han.host:cwd)))
  (or (null dir) (and (stringp dir) (pathnamep (han.host:directory-exists-p dir)))))
;; => T
```

Resolve a file supplied relative to a temporary working directory.

```lisp
(let ((root (uiop:ensure-directory-pathname (uiop:run-program '("mktemp" "-d") :output :line))))
  (unwind-protect
       (uiop:with-current-directory (root)
         (string= (namestring (han.path:absolute-pathname "draft.txt" (han.host:cwd)))
                  (namestring (merge-pathnames "draft.txt" (truename root)))))
    (uiop:delete-directory-tree root :validate t :if-does-not-exist :ignore)))
;; => T
```

[`han.host:working-directory-pathname`](working-directory-pathname.md) · [`han.os:current-directory`](../os/current-directory.md) · [common.lisp](../../../host/common.lisp) · [Index](../README.md)
