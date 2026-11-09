# `han.host:pathname-directory-list`

[简体中文](pathname-directory-list.zh-CN.md)

*Function*

## Syntax

```text
(han.host:pathname-directory-list path) → directory-list
```

## Description

Returns the directory component of a pathname or namestring as a list beginning with `:absolute` or `:relative`. A missing directory gives `(:relative)`. A string in the directory component names one top-level directory. Treat the returned list as read-only because it may belong to the pathname.

For a bare `:wild` directory, the pathname host chooses the wildcard representation it supports. The function signals an error if the host still supplies no directory levels or the directory is `:unspecific`. [Common Lisp HyperSpec, MAKE-PATHNAME](https://www.lispworks.com/documentation/HyperSpec/Body/f_mk_pn.htm)

## Examples

Inspect the parent directories of a relative file name.

```lisp
(han.host:pathname-directory-list "runs/inputs/counts.tsv")
;; => (:RELATIVE "runs" "inputs")
```

Construct a pathname from the name of a top-level directory.

```lisp
(han.host:pathname-directory-list
 (make-pathname :directory "archive" :name "notes" :type "txt"))
;; => (:ABSOLUTE "archive")
```

Inspect a file whose directory will be supplied by its caller.

```lisp
(han.host:pathname-directory-list "counts.tsv")
;; => (:RELATIVE)
```

[`han.path:->pathname`](../path/to-pathname.md) · [Source](../../../host/common.lisp) · [Index](../README.md)
