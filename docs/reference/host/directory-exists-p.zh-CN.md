# `han.host:directory-exists-p`

[English](directory-exists-p.md)

*函数*

## 语法

```text
(han.host:directory-exists-p path) → directory pathname or nil
```

## 说明

接受字符串或 pathname，把末尾分量转为目录形式再探测。已有目录返回目录 pathname，目录缺失或探测失败时返回 `nil`。

## 示例

查找 Han 的源码目录并确认结果是一个 pathname。

```lisp
(let ((dir (asdf:system-source-directory "han")))
  (pathnamep (han.host:directory-exists-p dir)))
;; => T
```

调用方要求输出目录时，识别误传的普通文件。

```lisp
(uiop:with-temporary-file (:pathname file)
  (han.host:directory-exists-p file))
;; => NIL
```

将不带末尾斜杠的名称探测为实际目录，再用返回的 pathname 构造子路径。

```lisp
(let ((root (uiop:ensure-directory-pathname (uiop:run-program '("mktemp" "-d") :output :line))))
  (unwind-protect
       (let* ((spelling (string-right-trim "/" (namestring root)))
              (found (han.host:directory-exists-p spelling)))
         (string= (namestring (merge-pathnames "sample.tsv" found))
                  (namestring (merge-pathnames "sample.tsv" (truename root)))))
    (uiop:delete-directory-tree root :validate t :if-does-not-exist :ignore)))
;; => T
```

[`han.host:file-exists-p`](file-exists-p.zh-CN.md) · [`han.path:directory-pathname`](../path/directory-pathname.zh-CN.md) · [common.lisp](../../../host/common.lisp) · [索引](../README.zh-CN.md)
