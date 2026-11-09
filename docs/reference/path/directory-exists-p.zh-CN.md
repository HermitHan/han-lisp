# `han.path:directory-exists-p`

[English](directory-exists-p.md)

*函数*

## 语法

```text
(han.path:directory-exists-p path) → directory-pathname-or-nil
```

## 说明

按目录探测输入。成功返回目录 pathname，否则返回 `nil`。后续查找可以直接使用返回值作为目录基准。

## 示例

查询 Han 源码目录，检查返回值是目录形式的 pathname。

```lisp
(let ((root (asdf:system-source-directory "han")))
  (han.path:directory-pathname-p (han.path:directory-exists-p root)))
;; => T
```

调用方要求输出目录时，识别误传的普通文件。

```lisp
(uiop:with-temporary-file (:pathname file)
  (han.path:directory-exists-p file))
;; => NIL
```

将不带末尾斜杠的名称探测为实际目录，再用返回的 pathname 构造子路径。

```lisp
(let ((root (uiop:ensure-directory-pathname (uiop:run-program '("mktemp" "-d") :output :line))))
  (unwind-protect
       (let* ((spelling (string-right-trim "/" (namestring root)))
              (found (han.path:directory-exists-p spelling)))
         (string= (namestring (merge-pathnames "sample.tsv" found))
                  (namestring (merge-pathnames "sample.tsv" (truename root)))))
    (uiop:delete-directory-tree root :validate t :if-does-not-exist :ignore)))
;; => T
```

[`han.path:directory-pathname-p`](directory-pathname-p.zh-CN.md) · [`han.path:directory-files`](directory-files.zh-CN.md) · [`han.host:directory-exists-p`](../host/directory-exists-p.zh-CN.md) · [源码](../../../path/core.lisp) · [索引](../README.zh-CN.md)
