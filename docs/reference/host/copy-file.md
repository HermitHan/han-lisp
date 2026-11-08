# `han.host:copy-file`

*Function · 函数*

## Syntax · 语法

```text
(han.host:copy-file source target) → target
```

## Description · 说明

Copies the bytes of the source file, creating parent directories as needed and replacing any existing target contents. Returns the original target argument. File errors propagate. Choose distinct paths for the source and destination. The example creates two temporary files.

按字节复制源文件，按需创建目标父目录并替换已有目标内容。返回原始 target 参数，文件错误向调用方传播。源和目标应使用不同路径。示例只操作两个临时文件。

## Examples · 示例

Copy a file containing one line and read the line from the destination.

复制一个含有一行文字的文件，再从目标文件中读回这一行。

```lisp
(uiop:with-temporary-file (:pathname source)
  (uiop:with-temporary-file (:pathname target)
    (han.host:append-utf8-line source "copied")
    (han.host:copy-file source target)
    (han.os:load-lines target)))
;; => ("copied")
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
    (han.host:copy-file source target)
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
                (written (han.host:copy-file source target)))
           (han.os:load-lines written)))
    (uiop:delete-directory-tree root :validate t :if-does-not-exist :ignore)))
;; => ("exported")
```

[`han.host:file-exists-p`](file-exists-p.md) · [`han.path:copy-file`](../path/copy-file.md) · [common.lisp](../../../host/common.lisp) · [Index · 索引](../README.md)
