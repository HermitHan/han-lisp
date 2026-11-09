# `han.path:relative-path`

[简体中文](relative-path.zh-CN.md)

*Function*

## Syntax

```text
(han.path:relative-path target &optional (base (han.host:working-directory-pathname))) → pathname
```

## Description

Resolves each argument independently against the current directory. Removes their common directory prefix and adds parent steps as needed. The result keeps the target's host and device. It returns the absolute target when the hosts or devices differ, or when a logical pathname would need a parent step. Logical namestrings have no notation for that step. To interpret a relative target inside a specified base, resolve it against that base first.

## Examples

Express a result file’s path relative to its run directory.

```lisp
(han.path:->namestring (han.path:relative-path "/work/run/out/data.tsv" "/work/run/"))
;; => "out/data.tsv"
```

Produce a reference from one sibling directory to another.

```lisp
(han.path:->namestring (han.path:relative-path "/work/inputs/ref.fa" "/work/reports/"))
;; => "../inputs/ref.fa"
```

Interpret a caller's relative target inside its project before storing the relative link in a manifest.

```lisp
(let* ((base "/work/archive/")
       (target (han.path:absolute-pathname "tables/counts.tsv" base)))
  (han.path:->namestring (han.path:relative-path target base)))
;; => "tables/counts.tsv"
```

[`han.path:absolute-pathname`](absolute-pathname.md) · [`han.path:parent-directory-pathname`](parent-directory-pathname.md) · [Source](../../../path/core.lisp) · [Index](../README.md)
