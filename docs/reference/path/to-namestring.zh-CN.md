# `han.path:->namestring`

[English](to-namestring.md)

*函数*

## 语法

```text
(han.path:->namestring x) → string
```

## 说明

先按 `->pathname` 处理，再取 namestring。分隔符及转义遵循当前 Lisp 实现。准备外部程序的参数或调用 `han.host:atomic-replace-file` 时，如果手中已有 Unix 文件名字符串，直接传原串即可。将它解析为 pathname 再转回字符串，可能改变特殊字符的拼写。

已命名的物理文件可用 `:unspecific` 表示没有扩展名。如果宿主无法直接表示这个 pathname，Han 仅以空 type 分量重试，保留其余分量。仍无法表示时触发 `file-error`，其 `file-error-pathname` 是经过 `->pathname` 处理的路径。转换不要求文件存在。

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

将没有扩展名的命令路径传给操作系统。

```lisp
(han.path:->namestring
 (make-pathname :directory '(:relative "bin") :name "wrapper"
                :type :unspecific :version :newest))
;; => "bin/wrapper"
```

[`han.path:->pathname`](to-pathname.zh-CN.md) · [`han.path:join-path`](join-path.zh-CN.md) · [`han.host:atomic-replace-file`](../host/atomic-replace-file.zh-CN.md) · [源码](../../../path/core.lisp) · [索引](../README.zh-CN.md)
