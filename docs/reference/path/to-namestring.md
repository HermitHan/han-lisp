# `han.path:->namestring`

[简体中文](to-namestring.zh-CN.md)

*Function*

## Syntax

```text
(han.path:->namestring x) → string
```

## Description

Converts a string or pathname using `->pathname`, then returns its namestring. Use this at an interface that needs a filename string, for example an OS argument list. Separators and escaping follow the Lisp implementation.

## Examples

Convert a joined pathname into a string for display.

```lisp
(han.path:->namestring (han.path:join-path "/work" "notes" "first.txt"))
;; => "/work/notes/first.txt"
```

Format a relative pathname for a relocatable project manifest.

```lisp
(mapcar #'han.path:->namestring
        (list #P"data/" (make-pathname :directory '(:relative "data")
                                       :name "counts" :type "tsv")))
;; => ("data/" "data/counts.tsv")
```

[`han.path:->pathname`](to-pathname.md) · [`han.path:join-path`](join-path.md) · [Source](../../../path/core.lisp) · [Index](../README.md)
