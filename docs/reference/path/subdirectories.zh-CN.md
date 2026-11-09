# `han.path:subdirectories`

[English](subdirectories.md)

*函数*

## 语法

```text
(han.path:subdirectories directory) → directory-pathnames
```

## 说明

列出直接子目录，各项均为可用于下一次遍历的目录 pathname。本次调用不递归进入子目录；列表顺序没有约定。

## 示例

在 Han 源码目录的直接子目录中查找 `json` 包目录。

```lisp
(let* ((root (asdf:system-source-directory "han"))
       (children (han.path:subdirectories root)))
  (not (null (find "json" children :test #'string=
                   :key (lambda (entry) (car (last (pathname-directory entry))))))))
;; => T
```

选出直接子目录，过滤普通文件和下下层目录。

```lisp
(let ((root (uiop:ensure-directory-pathname (uiop:run-program '("mktemp" "-d") :output :line))))
  (unwind-protect
       (progn
         (han.host:append-utf8-line (han.path:join-path root "jobs" "done" "x") "")
         (han.host:append-utf8-line (han.path:join-path root "notes.txt") "")
         (mapcar (lambda (dir) (car (last (pathname-directory dir))))
                 (han.path:subdirectories root)))
    (uiop:delete-directory-tree root :validate t :if-does-not-exist :ignore)))
;; => ("jobs")
```

目录中已有数据文件时，仍可判断它是否没有子目录。

```lisp
(let ((root (uiop:ensure-directory-pathname (uiop:run-program '("mktemp" "-d") :output :line))))
  (unwind-protect
       (progn
         (han.host:append-utf8-line (merge-pathnames "result.json" root) "{}")
         (if (han.path:subdirectories root) :branch :leaf))
    (uiop:delete-directory-tree root :validate t :if-does-not-exist :ignore)))
;; => :LEAF
```

[`han.path:directory-files`](directory-files.zh-CN.md) · [`han.path:directory-pathname`](directory-pathname.zh-CN.md) · [`han.host:subdirectories`](../host/subdirectories.zh-CN.md) · [源码](../../../path/core.lisp) · [索引](../README.zh-CN.md)
