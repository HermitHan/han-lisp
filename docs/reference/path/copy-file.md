# `han.path:copy-file`

*Function · 函数*

## Syntax · 语法

```text
(han.path:copy-file source target) → target
```

## Description · 说明

Copies bytes from an existing source into `target`, creating missing parent directories and replacing an existing target. Returns the original target argument. The operation can signal file errors. The example uses a temporary destination managed by UIOP.

按字节把已有源文件复制到目标。缺少的父目录会被创建，已有目标文件会被覆盖。返回传入的目标参数，文件操作失败可以报错。示例使用由 UIOP 清理的临时目标。

## Examples · 示例

Copy the ASDF definition to a temporary file and compare the first lines.

把 ASDF 定义复制到临时文件，再比较原件和副本的首行。

```lisp
(uiop:with-temporary-file (:pathname target)
  (let ((source (asdf:system-source-file "han")))
    (han.path:copy-file source target)
    (with-open-file (copy target)
      (with-open-file (original source)
        (string= (read-line original) (read-line copy))))))
;; => T
```

Replace a longer destination with binary data, including a zero byte.

用包含零字节的二进制数据替换较长的目标文件。

```lisp
(uiop:with-temporary-file (:pathname source)
  (uiop:with-temporary-file (:pathname target)
    (han.host:append-utf8-line target "longer old contents")
    (with-open-file (out source :direction :output :if-exists :supersede
                                :element-type '(unsigned-byte 8))
      (write-sequence #(0 255 13) out))
    (han.path:copy-file source target)
    (with-open-file (in target :element-type '(unsigned-byte 8))
      (list (file-length in) (read-byte in) (read-byte in) (read-byte in)))))
;; => (3 0 255 13)
```

Copy into a new nested directory and reuse the returned target path.

复制到新建的多级目录，并复用返回的目标路径。

```lisp
(let ((root (uiop:ensure-directory-pathname (uiop:run-program '("mktemp" "-d") :output :line))))
  (unwind-protect
       (uiop:with-temporary-file (:pathname source)
         (han.host:append-utf8-line source "exported")
         (let* ((target (han.path:join-path root "archive" "day1" "copy.tsv"))
                (written (han.path:copy-file source target)))
           (han.os:load-lines written)))
    (uiop:delete-directory-tree root :validate t :if-does-not-exist :ignore)))
;; => ("exported")
```

[`han.path:file-exists-p`](file-exists-p.md) · [`han.host:copy-file`](../host/copy-file.md) · [Source · 源码](../../../path/core.lisp) · [Index · 索引](../README.md)
