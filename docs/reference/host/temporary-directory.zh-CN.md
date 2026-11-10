# `han.host:temporary-directory`

[English](temporary-directory.md)

*函数*

## 语法

```text
(han.host:temporary-directory) → directory pathname
```

## 说明

依次读取 `TMPDIR`、`TEMP`、`TMP`，均缺失时使用 `/tmp/`。返回目录形式的 pathname。此操作不会创建目录、预留唯一文件名或验证可写性。

## 示例

确认临时目录以目录 pathname 表示。

```lisp
(han.path:directory-pathname-p (han.host:temporary-directory))
;; => T
```

在 Han 选定的临时目录下预留临时文件，操作完成后自动清理。

```lisp
(uiop:with-temporary-file (:directory (han.host:temporary-directory) :pathname scratch)
  (let ((parent (han.path:parent-directory-pathname scratch)))
    (string= (namestring (truename parent))
             (namestring (truename (han.host:temporary-directory))))))
;; => T
```

在子进程中移除三个临时目录变量，核对 Han 使用的回退路径。

```lisp
(nth-value 2
  (han.host:run-program-sync
   (list "/usr/bin/env" "-u" "TMPDIR" "-u" "TEMP" "-u" "TMP" #+(or ecl ccl) (first (han.host:argv t)) #-(or ecl ccl) (han.host:find-executable "sbcl")
         #+ecl "--norc" #+ccl "--no-init" #-(or ecl ccl) "--no-userinit"
         #+ecl "--nodebug" #+ccl "--batch" #-(or ecl ccl) "--non-interactive"
         "--load" (namestring (asdf:system-relative-pathname "han" "load-han.lisp"))
         "--eval" "(assert (string= \"/tmp/\" (namestring (han.host:temporary-directory))))" "--eval" "(han.host:quit)")))
;; => 0
```

[`han.host:getenv`](getenv.zh-CN.md) · [`han.host:directory-exists-p`](directory-exists-p.zh-CN.md) · [common.lisp](../../../host/common.lisp) · [索引](../README.zh-CN.md)
