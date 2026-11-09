# `han.host:delete-directory-tree`

[简体中文](delete-directory-tree.zh-CN.md)

*Function*

## Syntax

```text
(han.host:delete-directory-tree directory &key (validate t) (if-does-not-exist :ignore)) → t or nil
```

## Description

Recursively removes an existing directory via Unix `rm` and returns `t`. Validation checks the resolved directory and refuses the filesystem root. For a missing directory, `:ignore` returns `nil` and `:error` signals an error. Errors locating or running `rm` are reported. This example requests a child of a private regular file, so there is no directory to remove. The host passes the probed pathname to `rm`. If a directory symlink resolves to its target, that target and its contents can be removed.

## Examples

Ignore a missing directory during cleanup.

```lisp
(uiop:with-temporary-file (:pathname file)
  (let ((absent (han.path:join-path file "missing/")))
    (han.host:delete-directory-tree absent :if-does-not-exist :ignore)))
;; => NIL
```

Require the staging directory to exist and surface a missing-directory error.

```lisp
(uiop:with-temporary-file (:pathname regular-file)
  (han.host:delete-directory-tree (han.path:join-path regular-file "missing/")
                                  :if-does-not-exist :error))
;; signals simple-error
```

Remove a populated private scratch directory after a successful job.

```lisp
(let ((root (uiop:ensure-directory-pathname (uiop:run-program '("mktemp" "-d") :output :line))))
  (unwind-protect
       (progn
         (han.host:append-utf8-line (han.path:join-path root "cache" "result") "ok")
         (list (han.host:delete-directory-tree root) (han.host:directory-exists-p root)))
    (uiop:delete-directory-tree root :validate t :if-does-not-exist :ignore)))
;; => (T NIL)
```

[`han.host:directory-exists-p`](directory-exists-p.md) · [`han.path:delete-directory-tree`](../path/delete-directory-tree.md) · [common.lisp](../../../host/common.lisp) · [Index](../README.md)
