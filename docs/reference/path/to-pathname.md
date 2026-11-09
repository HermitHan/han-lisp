# `han.path:->pathname`

[简体中文](to-pathname.zh-CN.md)

*Function*

## Syntax

```text
(han.path:->pathname x) → pathname
```

## Description

Accepts a string or pathname. Strings use the Lisp implementation’s namestring syntax. A missing directory component becomes relative. Other directory components keep their host-defined representation, including wildcards. The path can describe a file that does not yet exist.

## Examples

Convert a relative path string and inspect its file name, type and directory components.

```lisp
(let ((file (han.path:->pathname "runs/report.json")))
  (list (pathname-name file) (pathname-type file) (pathname-directory file)))
;; => ("report" "json" (:RELATIVE "runs"))
```

Feed a directory pathname through a caller that accepts both strings and pathnames, and retain its directory shape.

```lisp
(let* ((directory #P"/tmp/project/")
       (converted (han.path:->pathname directory)))
  (list (pathnamep converted) (han.path:directory-pathname-p converted)
        (pathname-name converted)))
;; => (T T NIL)
```

[`han.path:->namestring`](to-namestring.md) · [`han.path:directory-pathname`](directory-pathname.md) · [`han.path:join-path`](join-path.md) · [Source](../../../path/core.lisp) · [Index](../README.md)
