# `han.path:->namestring`

[English](to-namestring.md)

*函数*

## 语法

```text
(han.path:->namestring x) → string
```

## 说明

先按 `->pathname` 处理，再取 namestring。调用需要文件名字符串的接口时可以使用它，例如准备外部程序的参数列表。分隔符及转义遵循当前 Lisp 实现。

## 示例

将拼好的 pathname 转成可显示的路径字符串。

```lisp
(han.path:->namestring (han.path:join-path "/work" "notes" "first.txt"))
;; => "/work/notes/first.txt"
```

将相对 pathname 转为适合可迁移清单的路径字符串。

```lisp
(mapcar #'han.path:->namestring
        (list #P"data/" (make-pathname :directory '(:relative "data")
                                       :name "counts" :type "tsv")))
;; => ("data/" "data/counts.tsv")
```

[`han.path:->pathname`](to-pathname.zh-CN.md) · [`han.path:join-path`](join-path.zh-CN.md) · [源码](../../../path/core.lisp) · [索引](../README.zh-CN.md)
