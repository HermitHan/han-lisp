# `han.os:current-directory`

[简体中文](current-directory.zh-CN.md)

*Function*

## Syntax

```text
(han.os:current-directory) → namestring or nil
```

## Description

Returns the current working directory as a namestring by delegating to `han.host:cwd`. Returns `nil` when the current directory cannot be resolved. For pathname operations pass the resulting string to `han.path`.

## Examples

Compare the current working directory with the value reported by the host.

```lisp
(equal (han.os:current-directory) (han.host:cwd))
;; => T
```

Resolve a project-relative filename under an explicitly scoped working directory.

```lisp
(let ((root (uiop:ensure-directory-pathname (uiop:run-program '("mktemp" "-d") :output :line))))
  (unwind-protect
       (uiop:with-current-directory (root)
         (string= (namestring (merge-pathnames "table.tsv" (truename root)))
                  (namestring (han.path:join-path (han.os:current-directory) "table.tsv"))))
    (uiop:delete-directory-tree root :validate t :if-does-not-exist :ignore)))
;; => T
```

[`han.os:home-directory`](home-directory.md) · [`han.host:cwd`](../host/cwd.md) · [env.lisp](../../../os/env.lisp) · [Index](../README.md)
