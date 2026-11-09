# `han.host:subdirectories`

[English](subdirectories.md)

*函数*

## 语法

```text
(han.host:subdirectories directory) → list of directory pathnames
```

## 说明

返回指定目录直接子目录的 pathname 列表，范围只到下一层。没有匹配项时返回 `nil`。示例在已加载的仓库中查找 host 包目录，不依赖列出顺序。

## 示例

在源码目录的直属子目录中查找 `host/` 模块。

```lisp
(let ((entries (han.host:subdirectories (asdf:system-source-directory "han"))))
  (not (null (find "host" entries :test #'string=
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
                 (han.host:subdirectories root)))
    (uiop:delete-directory-tree root :validate t :if-does-not-exist :ignore)))
;; => ("jobs")
```

目录中已有数据文件时，仍可判断它是否没有子目录。

```lisp
(let ((root (uiop:ensure-directory-pathname (uiop:run-program '("mktemp" "-d") :output :line))))
  (unwind-protect
       (progn
         (han.host:append-utf8-line (merge-pathnames "result.json" root) "{}")
         (if (han.host:subdirectories root) :branch :leaf))
    (uiop:delete-directory-tree root :validate t :if-does-not-exist :ignore)))
;; => :LEAF
```

[`han.host:directory-files`](directory-files.zh-CN.md) · [`han.host:directory-exists-p`](directory-exists-p.zh-CN.md) · [common.lisp](../../../host/common.lisp) · [索引](../README.zh-CN.md)
