# `han.host:temporary-directory`

*Function · 函数*

## Syntax · 语法

```text
(han.host:temporary-directory) → directory pathname
```

## Description · 说明

Selects the first available environment value among `TMPDIR`, `TEMP`, and `TMP`, falling back to `/tmp/`. Returns the selected path in directory form. This operation neither creates a directory nor reserves a unique name or verifies writability.

依次读取 `TMPDIR`、`TEMP`、`TMP`，均缺失时使用 `/tmp/`。返回目录形式的 pathname。此操作不会创建目录、预留唯一文件名或验证可写性。

## Examples · 示例

Check that the temporary directory is represented by a directory pathname.

确认临时目录以目录 pathname 表示。

```lisp
(han.path:directory-pathname-p (han.host:temporary-directory))
;; => T
```

Reserve a scratch file in Han's selected directory and remove it automatically at the end of the operation.

在 Han 选定的临时目录下预留临时文件，操作完成后自动清理。

```lisp
(uiop:with-temporary-file (:directory (han.host:temporary-directory) :pathname scratch)
  (let ((parent (han.path:parent-directory-pathname scratch)))
    (equal (truename parent) (truename (han.host:temporary-directory)))))
;; => T
```

Check the directory Han selects when TMPDIR, TEMP, and TMP are all absent.

在子进程中移除三个临时目录变量，核对 Han 使用的回退路径。

```lisp
(nth-value 2
  (han.host:run-program-sync
   (list "/usr/bin/env" "-u" "TMPDIR" "-u" "TEMP" "-u" "TMP" "sbcl" "--noinform" "--no-sysinit" "--no-userinit" "--disable-debugger"
         "--load" (namestring (asdf:system-relative-pathname "han" "load-han.lisp"))
         "--eval" "(assert (string= \"/tmp/\" (namestring (han.host:temporary-directory))))" "--quit")))
;; => 0
```

[`han.host:getenv`](getenv.md) · [`han.host:directory-exists-p`](directory-exists-p.md) · [common.lisp](../../../host/common.lisp) · [Index · 索引](../README.md)
