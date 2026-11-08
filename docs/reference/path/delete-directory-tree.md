# `han.path:delete-directory-tree`

*Function · 函数*

## Syntax · 语法

```text
(han.path:delete-directory-tree directory &key (validate t) (if-does-not-exist :ignore)) → t-or-nil
```

## Description · 说明

Recursively removes an existing directory and its contents using Unix `rm`. The default validation rejects the filesystem root. An absent directory returns `nil` with `:ignore` and signals an error with `:error`. The example removes a new directory reserved by `mktemp -d`. The host passes the probed pathname to `rm`. If a directory symlink resolves to its target, that target and its contents can be removed.

通过 Unix 的 `rm` 递归删除已有目录及其内容。默认校验会拒绝文件系统根目录。目录缺失时 `:ignore` 返回 `nil`，`:error` 发出错误。示例只删除由 `mktemp -d` 新建的目录。 传给 `rm` 的是探测得到的路径。若宿主将目录符号链接解析到目标目录，递归删除可能作用于目标及其内容。

## Examples · 示例

Delete a temporary directory and check whether it can still be found.

删除临时目录，再检查磁盘上是否还能找到它。

```lisp
(let ((scratch (uiop:run-program '("mktemp" "-d") :output :line)))
  (list (han.path:delete-directory-tree scratch) (han.path:directory-exists-p scratch)))
;; => (T NIL)
```

Require the staging directory to exist and surface a missing-directory error.

要求待清理的暂存目录必须存在，缺失时让调用方得到错误。

```lisp
(uiop:with-temporary-file (:pathname regular-file)
  (han.path:delete-directory-tree (han.path:join-path regular-file "missing/")
                                  :if-does-not-exist :error))
;; signals simple-error
```

Repeat cleanup after an earlier pass has already removed the private staging tree.

前一步已经清理了私有暂存树，再次清理时核对默认行为。

```lisp
(let ((root (uiop:ensure-directory-pathname (uiop:run-program '("mktemp" "-d") :output :line))))
  (unwind-protect
       (progn
         (han.host:append-utf8-line (han.path:join-path root "nested" "out") "ok")
         (list (han.path:delete-directory-tree root) (han.path:delete-directory-tree root)))
    (uiop:delete-directory-tree root :validate t :if-does-not-exist :ignore)))
;; => (T NIL)
```

[`han.path:directory-exists-p`](directory-exists-p.md) · [`han.path:temporary-directory`](temporary-directory.md) · [`han.host:delete-directory-tree`](../host/delete-directory-tree.md) · [Source · 源码](../../../path/core.lisp) · [Index · 索引](../README.md)
