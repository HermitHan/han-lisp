# `han.path:directory-pathname-p`

[简体中文](directory-pathname-p.zh-CN.md)

*Predicate*

## Syntax

```text
(han.path:directory-pathname-p x) → boolean
```

## Description

Tests whether both the name and type are absent. Each can be `nil` or `:unspecific` in a native pathname. It inspects syntax and performs no filesystem probe. A Unix string ending in a slash is a typical directory designator.

## Examples

Compare the same path spelling with and without a trailing slash.

```lisp
(list (han.path:directory-pathname-p "/draft/reports/")
      (han.path:directory-pathname-p "/draft/reports"))
;; => (T NIL)
```

Classify a proposed directory before it exists. Syntactic shape and successful probing are independent.

```lisp
(let ((root (uiop:ensure-directory-pathname (uiop:run-program '("mktemp" "-d") :output :line))))
  (unwind-protect
       (let ((future (han.path:join-path root "pending/")))
         (list (han.path:directory-pathname-p future) (han.path:directory-exists-p future)))
    (uiop:delete-directory-tree root :validate t :if-does-not-exist :ignore)))
;; => (T NIL)
```

[`han.path:directory-exists-p`](directory-exists-p.md) · [`han.path:directory-pathname`](directory-pathname.md) · [Source](../../../path/core.lisp) · [Index](../README.md)
