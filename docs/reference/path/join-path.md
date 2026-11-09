# `han.path:join-path`

[简体中文](join-path.zh-CN.md)

*Function*

## Syntax

```text
(han.path:join-path base &rest parts) → pathname
```

## Description

Merges the parts from left to right. Each intermediate result acts as a directory for the next part. With no parts it returns the base as a pathname. An absolute child can replace the preceding directory.

## Examples

Build the path to a sample’s configuration file from four components.

```lisp
(han.path:->namestring (han.path:join-path "/work" "samples" "S01" "config.json"))
;; => "/work/samples/S01/config.json"
```

Respect an explicitly absolute component supplied by a caller.

```lisp
(han.path:->namestring (han.path:join-path "/project/" "cache" "/shared/" "x.dat"))
;; => "/shared/x.dat"
```

Keep a relative base relative while inserting a dotted intermediate directory.

```lisp
(let ((file (han.path:join-path "results" "run.v2" "summary.tsv")))
  (list (han.path:absolute-pathname-p file) (han.path:->namestring file)))
;; => (NIL "results/run.v2/summary.tsv")
```

[`han.path:directory-pathname`](directory-pathname.md) · [`han.path:absolute-pathname`](absolute-pathname.md) · [`han.path:->namestring`](to-namestring.md) · [Source](../../../path/core.lisp) · [Index](../README.md)
