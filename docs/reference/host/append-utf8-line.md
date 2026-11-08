# `han.host:append-utf8-line`

*Function · 函数*

## Syntax · 语法

```text
(han.host:append-utf8-line path line) → file pathname
```

## Description · 说明

Appends the string `line` encoded as UTF-8, followed by one newline. An existing newline is retained. Creates missing parent directories and the file, then returns its pathname. OS strings are treated as literal filenames. An open or write failure signals an error. For multi-process transactions, use a shared lock.

将字符串 `line` 以 UTF-8 追加到文件，再写入一个换行符。字符串中原有的换行保留。自动创建缺少的父目录和文件，返回文件 pathname，字符串路径作为实际文件名。打开或写入失败时报错。需要跨进程协作时可配合共享锁。

## Examples · 示例

Append a Chinese line and an English line, then read them back in order.

依次追加一行中文和一行英文，再按写入顺序读回。

```lisp
(uiop:with-temporary-file (:pathname file)
  (han.host:append-utf8-line file "一")
  (han.host:append-utf8-line file "two")
  (han.os:load-lines file))
;; => ("一" "two")
```

Create missing parent directories on the first write.

首次追加时连同缺少的父目录一起创建。

```lisp
(let ((root (uiop:ensure-directory-pathname (uiop:run-program '("mktemp" "-d") :output :line))))
  (unwind-protect
       (let ((file (han.path:join-path root "history" "events.log")))
         (han.host:append-utf8-line file "start")
         (han.os:load-lines file))
    (uiop:delete-directory-tree root :validate t :if-does-not-exist :ignore)))
;; => ("start")
```

Store a blank record deliberately by passing an empty string.

传入空字符串，显式追加一条空记录。

```lisp
(uiop:with-temporary-file (:pathname log)
  (han.host:append-utf8-line log "")
  (han.os:load-lines log))
;; => ("")
```

[`han.host:call-with-exclusive-file-lock`](call-with-exclusive-file-lock.md) · [`han.os:load-lines`](../os/load-lines.md) · [sbcl.lisp](../../../host/sbcl.lisp) · [lispworks.lisp](../../../host/lispworks.lisp) · [Index · 索引](../README.md)
