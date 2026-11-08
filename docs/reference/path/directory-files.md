# `han.path:directory-files`

*Function · 函数*

## Syntax · 语法

```text
(han.path:directory-files directory) → file-pathnames
```

## Description · 说明

Returns a list of direct file children. Nested files and directories are omitted. An empty list can also result from a failed directory probe. Sort a copy before relying on any particular traversal order.

返回该目录的直接子文件列表。子目录及其内部的文件不在列表中。探测失败也可能返回空列表。若需要稳定顺序，可以在遍历之前对结果的副本排序。

## Examples · 示例

Find `han.asd` among the files listed in the Han source directory.

列出 Han 源码目录中的文件，从中查找 `han.asd`。

```lisp
(let ((files (han.path:directory-files (asdf:system-source-directory "han"))))
  (and (find "han.asd" files :key #'file-namestring :test #'string=) t))
;; => T
```

List the input files at one level while leaving the files in nested directories for a separate pass.

一次只枚举当前层的输入文件，子目录中的文件留给后续遍历。

```lisp
(let ((root (uiop:ensure-directory-pathname (uiop:run-program '("mktemp" "-d") :output :line))))
  (unwind-protect
       (progn
         (han.host:append-utf8-line (han.path:join-path root "input.txt") "a")
         (han.host:append-utf8-line (han.path:join-path root "nested" "child.txt") "b")
         (mapcar #'file-namestring (han.path:directory-files root)))
    (uiop:delete-directory-tree root :validate t :if-does-not-exist :ignore)))
;; => ("input.txt")
```

Build a stable import order for files created in a different order.

对按不同顺序创建的文件排序，得到可复现的导入顺序。

```lisp
(let ((root (uiop:ensure-directory-pathname (uiop:run-program '("mktemp" "-d") :output :line))))
  (unwind-protect
       (progn
         (dolist (name '("b.dat" "a.dat"))
           (han.host:append-utf8-line (merge-pathnames name root) "entry"))
         (sort (mapcar #'file-namestring (han.path:directory-files root)) #'string<))
    (uiop:delete-directory-tree root :validate t :if-does-not-exist :ignore)))
;; => ("a.dat" "b.dat")
```

[`han.path:subdirectories`](subdirectories.md) · [`han.path:directory-exists-p`](directory-exists-p.md) · [`han.host:directory-files`](../host/directory-files.md) · [Source · 源码](../../../path/core.lisp) · [Index · 索引](../README.md)
