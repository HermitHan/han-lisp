# `han.host:working-directory-pathname`

[简体中文](working-directory-pathname.zh-CN.md)

*Function*

## Syntax

```text
(han.host:working-directory-pathname) → pathname
```

## Description

Resolves the current directory with `truename` using the current `*default-pathname-defaults*`. Returns a directory pathname. A file-system error propagates to the caller if resolution fails. Use `han.host:cwd` when a display string with a `nil` fallback suits the caller.

## Examples

Get the working directory as a pathname and check that it exists.

```lisp
(let ((directory (han.host:working-directory-pathname)))
  (and (pathnamep directory)
       (pathnamep (han.host:directory-exists-p directory))))
;; => T
```

Resolve a relative report name with a temporary directory bound as the default.

```lisp
(let* ((*default-pathname-defaults* (truename (han.host:temporary-directory)))
       (report (merge-pathnames "report.txt" (han.host:working-directory-pathname))))
  (equal report (merge-pathnames "report.txt" *default-pathname-defaults*)))
;; => T
```

[`han.host:cwd`](cwd.md) · [common.lisp](../../../host/common.lisp) · [Index](../README.md)
