# `han.path:directory-pathname`

[简体中文](directory-pathname.zh-CN.md)

*Function*

## Syntax

```text
(han.path:directory-pathname x) → directory-pathname
```

## Description

Accepts a string or pathname. If it has a filename, the entire file namestring becomes the last directory component. Otherwise returns its directory form. This is a pathname transformation and does not create the directory.

## Examples

Treat `draft.v2` as a directory and keep the dot in its name.

```lisp
(han.path:->namestring (han.path:directory-pathname "draft.v2"))
;; => "draft.v2/"
```

Compare a newly normalized directory name with an already normalized one.

```lisp
(equal (han.path:directory-pathname "/work/reports")
       (han.path:directory-pathname #P"/work/reports/"))
;; => T
```

[`han.path:parent-directory-pathname`](parent-directory-pathname.md) · [`han.path:directory-pathname-p`](directory-pathname-p.md) · [`han.path:join-path`](join-path.md) · [Source](../../../path/core.lisp) · [Index](../README.md)
