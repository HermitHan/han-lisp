# `han.path:->namestring`

[简体中文](to-namestring.zh-CN.md)

*Function*

## Syntax

```text
(han.path:->namestring x) → string
```

## Description

Converts a string or pathname using `->pathname`, then returns its namestring. Separators and escaping follow the Lisp implementation. When passing an existing literal Unix filename to an OS argument list or to `han.host:atomic-replace-file`, use the original string. Converting it to a pathname and back can change how special characters are spelled.

A named physical file may have an explicit `:unspecific` type for an absent extension. If the host cannot spell that pathname directly, Han retries with a missing type and the same remaining components. If there is still no spelling, it signals a `file-error` whose `file-error-pathname` is the pathname returned by `->pathname`. The file need not exist.

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

Format an extensionless command pathname for an OS argument.

```lisp
(han.path:->namestring
 (make-pathname :directory '(:relative "bin") :name "wrapper"
                :type :unspecific :version :newest))
;; => "bin/wrapper"
```

[`han.path:->pathname`](to-pathname.md) · [`han.path:join-path`](join-path.md) · [`han.host:atomic-replace-file`](../host/atomic-replace-file.md) · [Source](../../../path/core.lisp) · [Index](../README.md)
