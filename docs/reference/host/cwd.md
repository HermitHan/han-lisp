# `han.host:cwd`

*Function · 函数*

## Syntax · 语法

```text
(han.host:cwd) → namestring or nil
```

## Description · 说明

Returns the namestring of `(truename ".")`, or `nil` when the current directory cannot be resolved. This returns a value suitable for display or for conversion to a pathname.

返回 `(truename ".")` 的目录名称字符串，无法解析时为 `nil`。结果可直接显示，也可以转换为 pathname。

## Examples · 示例

If a working directory is available, use its name to look up the directory.

如果能取得工作目录，就用返回的名称查找该目录。

```lisp
(let ((dir (han.host:cwd)))
  (or (null dir) (and (stringp dir) (pathnamep (han.host:directory-exists-p dir)))))
;; => T
```

Resolve a file supplied relative to a temporary working directory.

在临时工作目录下将用户传入的相对文件名解析为绝对路径。

```lisp
(let ((root (uiop:ensure-directory-pathname (uiop:run-program '("mktemp" "-d") :output :line))))
  (unwind-protect
       (uiop:with-current-directory (root)
         (equal (han.path:absolute-pathname "draft.txt" (han.host:cwd))
                (merge-pathnames "draft.txt" (truename root))))
    (uiop:delete-directory-tree root :validate t :if-does-not-exist :ignore)))
;; => T
```

[`han.host:directory-exists-p`](directory-exists-p.md) · [`han.os:current-directory`](../os/current-directory.md) · [common.lisp](../../../host/common.lisp) · [Index · 索引](../README.md)
