# `han.path:absolute-pathname`

[简体中文](absolute-pathname.zh-CN.md)

*Function*

## Syntax

```text
(han.path:absolute-pathname x &optional base) → pathname
```

## Description

Returns an absolute input as a pathname. Otherwise merges the input against the directory form of `base`, which defaults to the current directory. Supply an absolute base for an absolute result. It does not require the target to exist or resolve its symlinks.

## Examples

Resolve a relative table path against a project directory.

```lisp
(han.path:->namestring (han.path:absolute-pathname "tables/stats.tsv" "/work/project"))
;; => "/work/project/tables/stats.tsv"
```

Preserve an absolute override even when the caller supplies a different base.

```lisp
(han.path:->namestring (han.path:absolute-pathname "/shared/ref.fa" "/work/project"))
;; => "/shared/ref.fa"
```

Use the current working directory as the default base for a CLI input.

```lisp
(let ((root (uiop:ensure-directory-pathname (uiop:run-program '("mktemp" "-d") :output :line))))
  (unwind-protect
       (uiop:with-current-directory (root)
         (equal (han.path:absolute-pathname "next.json")
                (merge-pathnames "next.json" (truename root))))
    (uiop:delete-directory-tree root :validate t :if-does-not-exist :ignore)))
;; => T
```

[`han.path:absolute-pathname-p`](absolute-pathname-p.md) · [`han.path:relative-path`](relative-path.md) · [`han.path:join-path`](join-path.md) · [Source](../../../path/core.lisp) · [Index](../README.md)
