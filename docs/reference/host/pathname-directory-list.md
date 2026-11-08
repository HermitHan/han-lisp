# `han.host:pathname-directory-list`

*Function · 函数*

## Syntax · 语法

```text
(han.host:pathname-directory-list path) → directory-list
```

## Description · 说明

Returns the directory component of a pathname or namestring as a list beginning with `:absolute` or `:relative`. A missing directory gives `(:relative)`. A string in the directory component names one top-level directory. Treat the returned list as read-only because it may belong to the pathname.

接受 pathname 或 namestring，以 `:absolute` 或 `:relative` 开头的列表返回目录分量。缺少目录分量时返回 `(:relative)`。若目录分量本身是字符串，它表示一个顶层目录。返回的列表可能与原 pathname 共享，请按只读数据使用。

For a bare `:wild` directory, the pathname host chooses the wildcard representation it supports. The function signals an error if the host still supplies no directory levels or the directory is `:unspecific`. [Common Lisp HyperSpec, MAKE-PATHNAME](https://www.lispworks.com/documentation/HyperSpec/Body/f_mk_pn.htm)

若目录分量仅为 `:wild`，由该 pathname 的宿主选择支持的通配形式。若宿主仍然无法给出目录层级，或目录分量为 `:unspecific`，函数会报错。[Common Lisp HyperSpec，目录分量](https://www.lispworks.com/documentation/HyperSpec/Body/19_bbdc.htm)

## Examples · 示例

Inspect the parent directories of a relative file name.

读取相对文件名包含的各级目录。

```lisp
(han.host:pathname-directory-list "runs/inputs/counts.tsv")
;; => (:RELATIVE "runs" "inputs")
```

Construct a pathname from the name of a top-level directory.

用顶层目录名构造 pathname，再读取其目录层级。

```lisp
(han.host:pathname-directory-list
 (make-pathname :directory "archive" :name "notes" :type "txt"))
;; => (:ABSOLUTE "archive")
```

Inspect a file whose directory will be supplied by its caller.

读取尚待调用方指定目录的文件名。

```lisp
(han.host:pathname-directory-list "counts.tsv")
;; => (:RELATIVE)
```

[`han.path:->pathname`](../path/to-pathname.md) · [Source · 源码](../../../host/common.lisp) · [Index · 索引](../README.md)
