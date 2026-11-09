# `han.host:pathname-directory-list`

[English](pathname-directory-list.md)

*函数*

## 语法

```text
(han.host:pathname-directory-list path) → directory-list
```

## 说明

接受 pathname 或 namestring，以 `:absolute` 或 `:relative` 开头的列表返回目录分量。缺少目录分量时返回 `(:relative)`。若目录分量本身是字符串，它表示一个顶层目录。返回的列表可能与原 pathname 共享，请按只读数据使用。

若目录分量仅为 `:wild`，由该 pathname 的宿主选择支持的通配形式。若宿主仍然无法给出目录层级，或目录分量为 `:unspecific`，函数会报错。[Common Lisp HyperSpec，目录分量](https://www.lispworks.com/documentation/HyperSpec/Body/19_bbdc.htm)

## 示例

读取相对文件名包含的各级目录。

```lisp
(han.host:pathname-directory-list "runs/inputs/counts.tsv")
;; => (:RELATIVE "runs" "inputs")
```

用顶层目录名构造 pathname，再读取其目录层级。

```lisp
(han.host:pathname-directory-list
 (make-pathname :directory "archive" :name "notes" :type "txt"))
;; => (:ABSOLUTE "archive")
```

读取尚待调用方指定目录的文件名。

```lisp
(han.host:pathname-directory-list "counts.tsv")
;; => (:RELATIVE)
```

[`han.path:->pathname`](../path/to-pathname.zh-CN.md) · [源码](../../../host/common.lisp) · [索引](../README.zh-CN.md)
