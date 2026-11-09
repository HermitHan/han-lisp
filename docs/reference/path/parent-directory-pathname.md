# `han.path:parent-directory-pathname`

[简体中文](parent-directory-pathname.zh-CN.md)

*Function*

## Syntax

```text
(han.path:parent-directory-pathname x) → directory-pathname
```

## Description

For a file-like pathname, drops the filename, type and version. For directory input the directory itself is returned. Both branches operate on the pathname components without probing the disk.

## Examples

Compare the directory returned for a file with the result for its containing directory.

```lisp
(mapcar (lambda (p) (han.path:->namestring (han.path:parent-directory-pathname p)))
        '("/work/data/file.fa" "/work/data/"))
;; => ("/work/data/" "/work/data/")
```

Construct a sidecar next to a report using its directory and a new filename.

```lisp
(let ((directory (han.path:parent-directory-pathname "runs/job/result.tsv")))
  (han.path:->namestring (han.path:join-path directory "result.meta")))
;; => "runs/job/result.meta"
```

[`han.path:directory-pathname`](directory-pathname.md) · [`han.path:join-path`](join-path.md) · [Source](../../../path/core.lisp) · [Index](../README.md)
