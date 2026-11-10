# `han.host:atomic-replace-file`

[English](atomic-replace-file.md)

*函数*

## 语法

```text
(han.host:atomic-replace-file source target) → t
```

## 说明

通过一次文件系统重命名，将写好的普通文件 `source` 移到 `target` 指定的准确名称。两个参数都是非空字符串，每个字符须对应一个 Unicode 标量值，按 UTF-8 编码，不能含 NUL。空格、`*` 和 `?` 都是文件名中的普通字符。如果手中已有 Unix 文件名字符串，直接传入原串即可。相对名称以进程当前工作目录为基准。两边的父目录须已存在且位于同一文件系统。目标可以不存在，也可以是已有的普通文件。

成功时只返回 `t`。源目录项消失，打开目标会得到源文件的内容和权限位。如果目标已存在，在切换前后打开它的读者只能读到完整旧文件或完整新文件。已经打开的旧文件描述符仍指向旧文件。请在调用前写完暂存文件。需要在断电后保证数据持久化的应用，还应按需同步文件和目录。

非字符串参数触发 `type-error`。文件名无效或文件操作失败时触发 `file-error`。源或已有目标是目录、末级符号链接、FIFO 等特殊文件时会被拒绝。源与目标指向同一文件时也会被拒绝，包括指向同一 inode 的两个硬链接。目标是目录或重命名跨越文件系统时，两边的原状保留。哪些已有文件允许覆盖由调用方决定。调用方还须在操作期间保护两个目录项及其父目录，防止其他写入者并发调换。

## 示例

把暂存文件发布为新的无扩展名文件。

```lisp
(let* ((root (uiop:run-program '("mktemp" "-d") :output :line))
       (staged (concatenate 'string root "/staged.tmp"))
       (target (concatenate 'string root "/launcher")))
  (unwind-protect
       (progn
         (han.host:append-utf8-line staged "ready")
         (list (han.host:atomic-replace-file staged target)
               (han.os:load-lines target)
               (probe-file staged)))
    (uiop:delete-directory-tree (uiop:ensure-directory-pathname root)
                                :validate t)))
;; => (T ("ready") NIL)
```

替换已有文件，比较切换前打开的流和切换后打开的文件所读到的内容。

```lisp
(uiop:with-temporary-file (:pathname staged)
  (uiop:with-temporary-file (:pathname journal)
    (han.host:append-utf8-line journal "prepared")
    (han.host:append-utf8-line staged "committed")
    (with-open-file (earlier-reader journal :direction :input)
      (han.host:atomic-replace-file (namestring staged) (namestring journal))
      (list (read-line earlier-reader) (han.os:load-lines journal)))))
;; => ("prepared" ("committed"))
```

尝试将文件切换到目录名，捕获错误后仍可读回暂存文件。

```lisp
(uiop:with-temporary-file (:pathname staged)
  (han.host:append-utf8-line staged "keep")
  (let ((directory (uiop:pathname-directory-pathname staged)))
    (handler-case
        (han.host:atomic-replace-file (namestring staged) (namestring directory))
      (file-error () (han.os:load-lines staged)))))
;; => ("keep")
```

[`han.host:call-with-exclusive-file-lock`](call-with-exclusive-file-lock.zh-CN.md) · [`han.host:copy-file`](copy-file.zh-CN.md) · [源码](../../../host/common.lisp) · [索引](../README.zh-CN.md)
