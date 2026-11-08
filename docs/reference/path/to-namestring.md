# `han.path:->namestring`

*Function · 函数*

## Syntax · 语法

```text
(han.path:->namestring x) → string
```

## Description · 说明

Converts a string or pathname using `->pathname`, then returns its namestring. Use this at an interface that needs a filename string, for example an OS argument list. Separators and escaping follow the Lisp implementation.

先按 `->pathname` 处理，再取 namestring。调用需要文件名字符串的接口时可以使用它，例如准备外部程序的参数列表。分隔符及转义遵循当前 Lisp 实现。

## Examples · 示例

Convert a joined pathname into a string for display.

将拼好的 pathname 转成可显示的路径字符串。

```lisp
(han.path:->namestring (han.path:join-path "/work" "notes" "first.txt"))
;; => "/work/notes/first.txt"
```

Format a relative pathname for a relocatable project manifest.

将相对 pathname 转为适合可迁移清单的路径字符串。

```lisp
(mapcar #'han.path:->namestring
        (list #P"data/" (make-pathname :directory '(:relative "data")
                                       :name "counts" :type "tsv")))
;; => ("data/" "data/counts.tsv")
```

[`han.path:->pathname`](to-pathname.md) · [`han.path:join-path`](join-path.md) · [Source · 源码](../../../path/core.lisp) · [Index · 索引](../README.md)
