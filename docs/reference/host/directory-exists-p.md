# `han.host:directory-exists-p`

*Function · 函数*

## Syntax · 语法

```text
(han.host:directory-exists-p path) → directory pathname or nil
```

## Description · 说明

Accepts a string or pathname and coerces the final component to directory form. A successful directory probe returns a directory pathname. A missing directory or failed probe yields `nil`.

接受字符串或 pathname，把末尾分量转为目录形式再探测。已有目录返回目录 pathname，目录缺失或探测失败时返回 `nil`。

## Examples · 示例

Look up the Han source directory and check that the result is a pathname.

查找 Han 的源码目录并确认结果是一个 pathname。

```lisp
(let ((dir (asdf:system-source-directory "han")))
  (pathnamep (han.host:directory-exists-p dir)))
;; => T
```

Reject a regular file supplied where an output directory is required.

调用方要求输出目录时，识别误传的普通文件。

```lisp
(uiop:with-temporary-file (:pathname file)
  (han.host:directory-exists-p file))
;; => NIL
```

Resolve a directory given without a trailing slash and use it to construct a child path.

将不带末尾斜杠的名称探测为实际目录，再用返回的 pathname 构造子路径。

```lisp
(let ((root (uiop:ensure-directory-pathname (uiop:run-program '("mktemp" "-d") :output :line))))
  (unwind-protect
       (let* ((spelling (string-right-trim "/" (namestring root)))
              (found (han.host:directory-exists-p spelling)))
         (equal (merge-pathnames "sample.tsv" found)
                (merge-pathnames "sample.tsv" (truename root))))
    (uiop:delete-directory-tree root :validate t :if-does-not-exist :ignore)))
;; => T
```

[`han.host:file-exists-p`](file-exists-p.md) · [`han.path:directory-pathname`](../path/directory-pathname.md) · [common.lisp](../../../host/common.lisp) · [Index · 索引](../README.md)
