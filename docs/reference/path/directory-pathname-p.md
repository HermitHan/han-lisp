# `han.path:directory-pathname-p`

*Predicate · 谓词*

## Syntax · 语法

```text
(han.path:directory-pathname-p x) → boolean
```

## Description · 说明

Tests whether the interpreted pathname has neither a name nor a type. It inspects syntax and performs no filesystem probe. A Unix string ending in a slash is a typical directory designator.

判断所表示的 pathname 是否同时没有名称和类型分量，仅查看形式，不访问文件系统。Unix 路径末尾的斜杠通常用来表示目录。

## Examples · 示例

Compare the same path spelling with and without a trailing slash.

比较同一路径末尾带斜杠和不带斜杠时的判断结果。

```lisp
(list (han.path:directory-pathname-p "/draft/reports/")
      (han.path:directory-pathname-p "/draft/reports"))
;; => (T NIL)
```

Classify a proposed directory before it exists. Syntactic shape and successful probing are independent.

在目录尚未创建时判断名称是否为目录形式，并与真实存在性区分。

```lisp
(let ((root (uiop:ensure-directory-pathname (uiop:run-program '("mktemp" "-d") :output :line))))
  (unwind-protect
       (let ((future (han.path:join-path root "pending/")))
         (list (han.path:directory-pathname-p future) (han.path:directory-exists-p future)))
    (uiop:delete-directory-tree root :validate t :if-does-not-exist :ignore)))
;; => (T NIL)
```

[`han.path:directory-exists-p`](directory-exists-p.md) · [`han.path:directory-pathname`](directory-pathname.md) · [Source · 源码](../../../path/core.lisp) · [Index · 索引](../README.md)
