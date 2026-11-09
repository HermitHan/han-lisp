# `han.path:parent-directory-pathname`

[English](parent-directory-pathname.md)

*函数*

## 语法

```text
(han.path:parent-directory-pathname x) → directory-pathname
```

## 说明

对文件形式的输入去掉名称、类型和版本，得到所属目录；对目录形式的输入返回该目录本身。两个分支都只处理 pathname 分量。

## 示例

比较传入文件路径和传入其所在目录时，函数分别返回哪个目录。

```lisp
(mapcar (lambda (p) (han.path:->namestring (han.path:parent-directory-pathname p)))
        '("/work/data/file.fa" "/work/data/"))
;; => ("/work/data/" "/work/data/")
```

从报告路径取出目录，生成同一目录下的附属文件。

```lisp
(let ((directory (han.path:parent-directory-pathname "runs/job/result.tsv")))
  (han.path:->namestring (han.path:join-path directory "result.meta")))
;; => "runs/job/result.meta"
```

[`han.path:directory-pathname`](directory-pathname.zh-CN.md) · [`han.path:join-path`](join-path.zh-CN.md) · [源码](../../../path/core.lisp) · [索引](../README.zh-CN.md)
