# `han.host:delete-directory-tree`

*Function · 函数*

## Syntax · 语法

```text
(han.host:delete-directory-tree directory &key (validate t) (if-does-not-exist :ignore)) → t or nil
```

## Description · 说明

Recursively removes an existing directory via Unix `rm` and returns `t`. Validation checks the resolved directory and refuses the filesystem root. For a missing directory, `:ignore` returns `nil` and `:error` signals an error. Errors locating or running `rm` are reported. This example requests a child of a private regular file, so there is no directory to remove. The host passes the probed pathname to `rm`. If a directory symlink resolves to its target, that target and its contents can be removed.

通过 Unix 的 `rm` 递归删除已存在的目录，成功返回 `t`。默认校验会检查解析后的目录，拒绝文件系统根目录。目标缺失时，`:ignore` 返回 `nil`，`:error` 报错。无法找到或运行 `rm` 时也会报告错误。示例选择私有临时普通文件下面的子路径，该位置不可能存在目录。 传给 `rm` 的是探测得到的路径。若宿主将目录符号链接解析到目标目录，递归删除可能作用于目标及其内容。

## Examples · 示例

Ignore a missing directory during cleanup.

清理时忽略已经不存在的目录。

```lisp
(uiop:with-temporary-file (:pathname file)
  (let ((absent (han.path:join-path file "missing/")))
    (han.host:delete-directory-tree absent :if-does-not-exist :ignore)))
;; => NIL
```

Require the staging directory to exist and surface a missing-directory error.

要求待清理的暂存目录必须存在，缺失时让调用方得到错误。

```lisp
(uiop:with-temporary-file (:pathname regular-file)
  (han.host:delete-directory-tree (han.path:join-path regular-file "missing/")
                                  :if-does-not-exist :error))
;; signals simple-error
```

Remove a populated private scratch directory after a successful job.

作业完成后递归移除包含结果文件的私有临时目录。

```lisp
(let ((root (uiop:ensure-directory-pathname (uiop:run-program '("mktemp" "-d") :output :line))))
  (unwind-protect
       (progn
         (han.host:append-utf8-line (han.path:join-path root "cache" "result") "ok")
         (list (han.host:delete-directory-tree root) (han.host:directory-exists-p root)))
    (uiop:delete-directory-tree root :validate t :if-does-not-exist :ignore)))
;; => (T NIL)
```

[`han.host:directory-exists-p`](directory-exists-p.md) · [`han.path:delete-directory-tree`](../path/delete-directory-tree.md) · [common.lisp](../../../host/common.lisp) · [Index · 索引](../README.md)
