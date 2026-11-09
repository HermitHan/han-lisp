# `han.path:absolute-pathname-p`

[简体中文](absolute-pathname-p.zh-CN.md)

*Predicate*

## Syntax

```text
(han.path:absolute-pathname-p x) → boolean
```

## Description

Recognizes a directory list beginning with `:absolute`, a top-level directory represented by a string, and a bare `:wild` directory. It checks pathname components without probing the file system.

## Examples

Compare an absolute Unix path with a relative file name.

```lisp
(list (han.path:absolute-pathname-p "/work/a") (han.path:absolute-pathname-p "a"))
;; => (T NIL)
```

Decide whether an input should be resolved against a project root.

```lisp
(let ((base "/work/project"))
  (mapcar (lambda (input)
            (han.path:->namestring
             (if (han.path:absolute-pathname-p input)
                 input
                 (han.path:join-path base input))))
          '("data/raw.tsv" "/shared/ref.tsv")))
;; => ("/work/project/data/raw.tsv" "/shared/ref.tsv")
```

[`han.path:absolute-pathname`](absolute-pathname.md) · [`han.path:relative-path`](relative-path.md) · [Source](../../../path/core.lisp) · [Index](../README.md)
