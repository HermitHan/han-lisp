# `han.host:file-exists-p`

*Function · 函数*

## Syntax · 语法

```text
(han.host:file-exists-p path) → file pathname or nil
```

## Description · 说明

Accepts a filename string or pathname. Returns the probed pathname for an existing file. A directory or a failed probe yields `nil`. Use the returned pathname when opening the file.

接受文件名字符串或 pathname。已有文件返回探测到的 pathname，传入目录或探测未成功时返回 `nil`。成功后可直接使用该 pathname 打开文件。

## Examples · 示例

Look up a temporary file and check that its pathname is returned.

查找一个临时文件，确认返回的是它的 pathname。

```lisp
(uiop:with-temporary-file (:pathname file)
  (pathnamep (han.host:file-exists-p file)))
;; => T
```

Treat a missing optional sidecar as absent before trying to read it.

在读取可选的附属文件前，检查它是否缺失。

```lisp
(let ((root (uiop:ensure-directory-pathname (uiop:run-program '("mktemp" "-d") :output :line))))
  (unwind-protect
       (han.host:file-exists-p (han.path:join-path root "report.meta"))
    (uiop:delete-directory-tree root :validate t :if-does-not-exist :ignore)))
;; => NIL
```

Use the returned pathname directly to open a verified input file.

使用返回的 pathname 直接打开已确认存在的输入文件。

```lisp
(uiop:with-temporary-file (:pathname input)
  (han.host:append-utf8-line input "sample-17")
  (let ((found (han.host:file-exists-p (namestring input))))
    (and found (with-open-file (stream found) (read-line stream)))))
;; => "sample-17"
```

[`han.host:directory-exists-p`](directory-exists-p.md) · [`han.path:file-exists-p`](../path/file-exists-p.md) · [common.lisp](../../../host/common.lisp) · [Index · 索引](../README.md)
