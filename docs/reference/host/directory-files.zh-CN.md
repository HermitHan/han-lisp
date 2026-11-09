# `han.host:directory-files`

[English](directory-files.md)

*函数*

## 语法

```text
(han.host:directory-files directory) → list of pathnames
```

## 说明

列出 `directory` 的直接子文件。实现合并本地路径模式的结果，去重并核对每个文件确实直接位于指定目录。无匹配时返回 `nil`，需要固定顺序时应自行排序。

## 示例

在仓库根目录的文件列表里查找系统定义文件 `han.asd`。

```lisp
(let ((entries (han.host:directory-files (asdf:system-source-directory "han"))))
  (not (null (find "han.asd" entries :key #'file-namestring :test #'string=))))
;; => T
```

一次只枚举当前层的输入文件，子目录中的文件留给后续遍历。

```lisp
(let ((root (uiop:ensure-directory-pathname (uiop:run-program '("mktemp" "-d") :output :line))))
  (unwind-protect
       (progn
         (han.host:append-utf8-line (han.path:join-path root "input.txt") "a")
         (han.host:append-utf8-line (han.path:join-path root "nested" "child.txt") "b")
         (mapcar #'file-namestring (han.host:directory-files root)))
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
         (sort (mapcar #'file-namestring (han.host:directory-files root)) #'string<))
    (uiop:delete-directory-tree root :validate t :if-does-not-exist :ignore)))
;; => ("a.dat" "b.dat")
```

[`han.host:subdirectories`](subdirectories.zh-CN.md) · [`han.host:file-exists-p`](file-exists-p.zh-CN.md) · [common.lisp](../../../host/common.lisp) · [索引](../README.zh-CN.md)
