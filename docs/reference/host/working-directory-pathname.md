# `han.host:working-directory-pathname`

*Function · 函数*

## Syntax · 语法

```text
(han.host:working-directory-pathname) → pathname
```

## Description · 说明

Resolves the current directory with `truename` using the current `*default-pathname-defaults*`. Returns a directory pathname. A file-system error propagates to the caller if resolution fails. Use `han.host:cwd` when a display string with a `nil` fallback suits the caller.

依照当前的 `*default-pathname-defaults*`，用 `truename` 解析当前目录，返回目录路径名。无法解析时，文件系统错误会传递给调用者。如果用于显示，且允许失败时返回 `nil`，可用 `han.host:cwd`。

## Examples · 示例

Get the working directory as a pathname and check that it exists.

取得工作目录的路径名，并检查对应目录存在。

```lisp
(let ((directory (han.host:working-directory-pathname)))
  (and (pathnamep directory)
       (pathnamep (han.host:directory-exists-p directory))))
;; => T
```

Resolve a relative report name with a temporary directory bound as the default.

临时绑定默认目录，在该目录下解析相对报告文件名。

```lisp
(let* ((*default-pathname-defaults* (truename (han.host:temporary-directory)))
       (report (merge-pathnames "report.txt" (han.host:working-directory-pathname))))
  (equal report (merge-pathnames "report.txt" *default-pathname-defaults*)))
;; => T
```

[`han.host:cwd`](cwd.md) · [common.lisp](../../../host/common.lisp) · [Index · 索引](../README.md)
