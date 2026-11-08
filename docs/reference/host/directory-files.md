# `han.host:directory-files`

*Function · 函数*

## Syntax · 语法

```text
(han.host:directory-files directory) → list of pathnames
```

## Description · 说明

Lists the files immediately below `directory`. Enumeration combines native pathname patterns, removes duplicate entries and checks that a file belongs directly to the requested directory. An empty result is `nil`. If ordering matters, sort the returned list.

列出 `directory` 的直接子文件。实现合并本地路径模式的结果，去重并核对每个文件确实直接位于指定目录。无匹配时返回 `nil`，需要固定顺序时应自行排序。

## Examples · 示例

Find the system definition named `han.asd` among the files in the checkout root.

在仓库根目录的文件列表里查找系统定义文件 `han.asd`。

```lisp
(let ((entries (han.host:directory-files (asdf:system-source-directory "han"))))
  (not (null (find "han.asd" entries :key #'file-namestring :test #'string=))))
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
         (mapcar #'file-namestring (han.host:directory-files root)))
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
         (sort (mapcar #'file-namestring (han.host:directory-files root)) #'string<))
    (uiop:delete-directory-tree root :validate t :if-does-not-exist :ignore)))
;; => ("a.dat" "b.dat")
```

[`han.host:subdirectories`](subdirectories.md) · [`han.host:file-exists-p`](file-exists-p.md) · [common.lisp](../../../host/common.lisp) · [Index · 索引](../README.md)
