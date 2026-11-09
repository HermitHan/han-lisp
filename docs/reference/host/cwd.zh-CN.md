# `han.host:cwd`

[English](cwd.md)

*函数*

## 语法

```text
(han.host:cwd) → namestring or nil
```

## 说明

返回工作目录解析后的名称字符串，无法解析时为 `nil`。结果可直接显示，也可以转换为 pathname。

## 示例

如果能取得工作目录，就用返回的名称查找该目录。

```lisp
(let ((dir (han.host:cwd)))
  (or (null dir) (and (stringp dir) (pathnamep (han.host:directory-exists-p dir)))))
;; => T
```

在临时工作目录下将用户传入的相对文件名解析为绝对路径。

```lisp
(let ((root (uiop:ensure-directory-pathname (uiop:run-program '("mktemp" "-d") :output :line))))
  (unwind-protect
       (uiop:with-current-directory (root)
         (string= (namestring (han.path:absolute-pathname "draft.txt" (han.host:cwd)))
                  (namestring (merge-pathnames "draft.txt" (truename root)))))
    (uiop:delete-directory-tree root :validate t :if-does-not-exist :ignore)))
;; => T
```

[`han.host:working-directory-pathname`](working-directory-pathname.zh-CN.md) · [`han.os:current-directory`](../os/current-directory.zh-CN.md) · [common.lisp](../../../host/common.lisp) · [索引](../README.zh-CN.md)
