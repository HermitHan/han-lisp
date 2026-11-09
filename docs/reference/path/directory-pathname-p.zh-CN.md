# `han.path:directory-pathname-p`

[English](directory-pathname-p.md)

*谓词*

## 语法

```text
(han.path:directory-pathname-p x) → boolean
```

## 说明

判断 pathname 的名称和类型分量是否都缺失。原生 pathname 可以用 `nil` 或 `:unspecific` 表示这两种分量缺失。这个判断只查看路径形式，无需访问文件系统。Unix 路径末尾的斜杠通常用来表示目录。

## 示例

比较同一路径末尾带斜杠和不带斜杠时的判断结果。

```lisp
(list (han.path:directory-pathname-p "/draft/reports/")
      (han.path:directory-pathname-p "/draft/reports"))
;; => (T NIL)
```

在目录尚未创建时判断名称是否为目录形式，并与真实存在性区分。

```lisp
(let ((root (uiop:ensure-directory-pathname (uiop:run-program '("mktemp" "-d") :output :line))))
  (unwind-protect
       (let ((future (han.path:join-path root "pending/")))
         (list (han.path:directory-pathname-p future) (han.path:directory-exists-p future)))
    (uiop:delete-directory-tree root :validate t :if-does-not-exist :ignore)))
;; => (T NIL)
```

[`han.path:directory-exists-p`](directory-exists-p.zh-CN.md) · [`han.path:directory-pathname`](directory-pathname.zh-CN.md) · [源码](../../../path/core.lisp) · [索引](../README.zh-CN.md)
