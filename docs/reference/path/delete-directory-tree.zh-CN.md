# `han.path:delete-directory-tree`

[English](delete-directory-tree.md)

*函数*

## 语法

```text
(han.path:delete-directory-tree directory &key (validate t) (if-does-not-exist :ignore)) → t-or-nil
```

## 说明

通过 Unix 的 `rm` 递归删除已有目录及其内容。默认校验会拒绝文件系统根目录。目录缺失时 `:ignore` 返回 `nil`，`:error` 发出错误。示例只删除由 `mktemp -d` 新建的目录。 传给 `rm` 的是探测得到的路径。若宿主将目录符号链接解析到目标目录，递归删除可能作用于目标及其内容。

## 示例

删除临时目录，再检查磁盘上是否还能找到它。

```lisp
(let ((scratch (uiop:run-program '("mktemp" "-d") :output :line)))
  (list (han.path:delete-directory-tree scratch) (han.path:directory-exists-p scratch)))
;; => (T NIL)
```

要求待清理的暂存目录必须存在，缺失时让调用方得到错误。

```lisp
(uiop:with-temporary-file (:pathname regular-file)
  (han.path:delete-directory-tree (han.path:join-path regular-file "missing/")
                                  :if-does-not-exist :error))
;; signals simple-error
```

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

[`han.path:directory-exists-p`](directory-exists-p.zh-CN.md) · [`han.path:temporary-directory`](temporary-directory.zh-CN.md) · [`han.host:delete-directory-tree`](../host/delete-directory-tree.zh-CN.md) · [源码](../../../path/core.lisp) · [索引](../README.zh-CN.md)
