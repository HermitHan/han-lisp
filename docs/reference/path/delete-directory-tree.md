# `han.path:delete-directory-tree`

[简体中文](delete-directory-tree.zh-CN.md)

*Function*

## Syntax

```text
(han.path:delete-directory-tree directory &key (validate t) (if-does-not-exist :ignore)) → t-or-nil
```

## Description

Recursively removes an existing directory and its contents using Unix `rm`. The default validation rejects the filesystem root. An absent directory returns `nil` with `:ignore` and signals an error with `:error`. The example removes a new directory reserved by `mktemp -d`. The host passes the probed pathname to `rm`. If a directory symlink resolves to its target, that target and its contents can be removed.

## Examples

Delete a temporary directory and check whether it can still be found.

```lisp
(let ((scratch (uiop:run-program '("mktemp" "-d") :output :line)))
  (list (han.path:delete-directory-tree scratch) (han.path:directory-exists-p scratch)))
;; => (T NIL)
```

Require the staging directory to exist and surface a missing-directory error.

```lisp
(uiop:with-temporary-file (:pathname regular-file)
  (han.path:delete-directory-tree (han.path:join-path regular-file "missing/")
                                  :if-does-not-exist :error))
;; signals simple-error
```

Repeat cleanup after an earlier pass has already removed the private staging tree.

```lisp
(let ((root (uiop:ensure-directory-pathname (uiop:run-program '("mktemp" "-d") :output :line))))
  (unwind-protect
       (progn
         (han.host:append-utf8-line (han.path:join-path root "nested" "out") "ok")
         (list (han.path:delete-directory-tree root) (han.path:delete-directory-tree root)))
    (uiop:delete-directory-tree root :validate t :if-does-not-exist :ignore)))
;; => (T NIL)
```

[`han.path:directory-exists-p`](directory-exists-p.md) · [`han.path:temporary-directory`](temporary-directory.md) · [`han.host:delete-directory-tree`](../host/delete-directory-tree.md) · [Source](../../../path/core.lisp) · [Index](../README.md)
