# `han.path:relative-path`

[English](relative-path.md)

*函数*

## 语法

```text
(han.path:relative-path target &optional (base (han.host:working-directory-pathname))) → pathname
```

## 说明

先分别以当前目录补全两个参数，再去掉共同目录前缀，并按需要插入上行目录分量。结果保留目标的 host 和 device。两者的 host 或 device 不同时返回绝对目标。若逻辑路径需要向上一级，也返回绝对目标，因为逻辑路径的 namestring 没有上行写法。若相对目标应位于给定基准内，先用 `absolute-pathname` 按那个基准补全。

## 示例

以运行目录为基准，求出结果文件的相对路径。

```lisp
(han.path:->namestring (han.path:relative-path "/work/run/out/data.tsv" "/work/run/"))
;; => "out/data.tsv"
```

生成从一个同级目录指向另一个目录中的文件的相对引用。

```lisp
(han.path:->namestring (han.path:relative-path "/work/inputs/ref.fa" "/work/reports/"))
;; => "../inputs/ref.fa"
```

先按调用方指定的项目解释相对目标，再存储相对于项目目录的引用。

```lisp
(let* ((base "/work/archive/")
       (target (han.path:absolute-pathname "tables/counts.tsv" base)))
  (han.path:->namestring (han.path:relative-path target base)))
;; => "tables/counts.tsv"
```

[`han.path:absolute-pathname`](absolute-pathname.zh-CN.md) · [`han.path:parent-directory-pathname`](parent-directory-pathname.zh-CN.md) · [源码](../../../path/core.lisp) · [索引](../README.zh-CN.md)
