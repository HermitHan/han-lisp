# `han.host:copy-file`

[English](copy-file.md)

*函数*

## 语法

```text
(han.host:copy-file source target) → target
```

## 说明

按字节复制源文件，按需创建目标父目录并替换已有目标内容。返回原始 target 参数，文件错误向调用方传播。源和目标应使用不同路径。示例只操作两个临时文件。

需要将写好的文件一步切换到最终名称时，使用 [`atomic-replace-file`](atomic-replace-file.zh-CN.md)。

## 示例

复制一个含有一行文字的文件，再从目标文件中读回这一行。

```lisp
(uiop:with-temporary-file (:pathname source)
  (uiop:with-temporary-file (:pathname target)
    (han.host:append-utf8-line source "copied")
    (han.host:copy-file source target)
    (han.os:load-lines target)))
;; => ("copied")
```

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

[`han.host:file-exists-p`](file-exists-p.zh-CN.md) · [`han.path:copy-file`](../path/copy-file.zh-CN.md) · [common.lisp](../../../host/common.lisp) · [索引](../README.zh-CN.md)
