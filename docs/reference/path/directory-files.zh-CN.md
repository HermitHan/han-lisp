# `han.path:directory-files`

[English](directory-files.md)

*函数*

## 语法

```text
(han.path:directory-files directory) → file-pathnames
```

## 说明

返回该目录的直接子文件列表。子目录及其内部的文件不在列表中。探测失败也可能返回空列表。若需要稳定顺序，可以在遍历之前对结果的副本排序。

## 示例

列出 Han 源码目录中的文件，从中查找 `han.asd`。

```lisp
(let ((files (han.path:directory-files (asdf:system-source-directory "han"))))
  (and (find "han.asd" files :key #'file-namestring :test #'string=) t))
;; => T
```

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

[`han.path:subdirectories`](subdirectories.zh-CN.md) · [`han.path:directory-exists-p`](directory-exists-p.zh-CN.md) · [`han.host:directory-files`](../host/directory-files.zh-CN.md) · [源码](../../../path/core.lisp) · [索引](../README.zh-CN.md)
