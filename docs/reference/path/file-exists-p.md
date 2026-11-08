# `han.path:file-exists-p`

*Function · 函数*

## Syntax · 语法

```text
(han.path:file-exists-p path) → file-pathname-or-nil
```

## Description · 说明

Probes for an existing file and returns the pathname obtained by the host, otherwise `nil`. A directory does not satisfy the file test. The example locates the loaded system’s definition through ASDF.

探测已有文件。找到时返回宿主取得的文件 pathname，否则返回 `nil`。目录不满足文件测试。示例通过 ASDF 查找已加载系统的定义文件。

## Examples · 示例

Probe the ASDF file and its containing directory with the same file predicate.

用同一个文件查询函数分别检查 ASDF 文件和它所在的目录。

```lisp
(let ((definition (asdf:system-source-file "han")))
  (list (pathnamep (han.path:file-exists-p definition))
        (han.path:file-exists-p (han.path:parent-directory-pathname definition))))
;; => (T NIL)
```

Treat a missing optional sidecar as absent before trying to read it.

在读取可选的附属文件前，检查它是否缺失。

```lisp
(let ((root (uiop:ensure-directory-pathname (uiop:run-program '("mktemp" "-d") :output :line))))
  (unwind-protect
       (han.path:file-exists-p (han.path:join-path root "report.meta"))
    (uiop:delete-directory-tree root :validate t :if-does-not-exist :ignore)))
;; => NIL
```

Use the returned pathname directly to open a verified input file.

使用返回的 pathname 直接打开已确认存在的输入文件。

```lisp
(uiop:with-temporary-file (:pathname input)
  (han.host:append-utf8-line input "sample-17")
  (let ((found (han.path:file-exists-p (namestring input))))
    (and found (with-open-file (stream found) (read-line stream)))))
;; => "sample-17"
```

[`han.path:directory-exists-p`](directory-exists-p.md) · [`han.host:file-exists-p`](../host/file-exists-p.md) · [Source · 源码](../../../path/core.lisp) · [Index · 索引](../README.md)
