# `han.host:working-directory-pathname`

[English](working-directory-pathname.md)

*函数*

## 语法

```text
(han.host:working-directory-pathname) → pathname
```

## 说明

依照当前的 `*default-pathname-defaults*`，用 `truename` 解析当前目录，返回目录路径名。无法解析时，文件系统错误会传递给调用者。如果用于显示，且允许失败时返回 `nil`，可用 `han.host:cwd`。

## 示例

取得工作目录的路径名，并检查对应目录存在。

```lisp
(let ((directory (han.host:working-directory-pathname)))
  (and (pathnamep directory)
       (pathnamep (han.host:directory-exists-p directory))))
;; => T
```

临时绑定默认目录，在该目录下解析相对报告文件名。

```lisp
(let* ((*default-pathname-defaults* (truename (han.host:temporary-directory)))
       (report (merge-pathnames "report.txt" (han.host:working-directory-pathname))))
  (equal report (merge-pathnames "report.txt" *default-pathname-defaults*)))
;; => T
```

[`han.host:cwd`](cwd.zh-CN.md) · [common.lisp](../../../host/common.lisp) · [索引](../README.zh-CN.md)
