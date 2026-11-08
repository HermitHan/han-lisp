# `han.path:relative-path`

*Function · 函数*

## Syntax · 语法

```text
(han.path:relative-path target &optional (base (truename "."))) → pathname
```

## Description · 说明

Resolves each argument independently against the current directory. Removes their common directory prefix and adds parent steps as needed. With different pathname hosts or devices it returns the absolute target. To interpret a relative target inside a specified base, resolve it against that base first.

先分别以当前目录补全两个参数，再去掉共同目录前缀，并按需要插入上行目录分量。host 或 device 不同时返回绝对目标；若相对目标应位于给定基准内，先用 `absolute-pathname` 按那个基准补全。

## Examples · 示例

Express a result file’s path relative to its run directory.

以运行目录为基准，求出结果文件的相对路径。

```lisp
(han.path:->namestring (han.path:relative-path "/work/run/out/data.tsv" "/work/run/"))
;; => "out/data.tsv"
```

Produce a reference from one sibling directory to another.

生成从一个同级目录指向另一个目录中的文件的相对引用。

```lisp
(han.path:->namestring (han.path:relative-path "/work/inputs/ref.fa" "/work/reports/"))
;; => "../inputs/ref.fa"
```

Interpret a caller's relative target inside its project before storing the relative link in a manifest.

先按调用方指定的项目解释相对目标，再存储相对于项目目录的引用。

```lisp
(let* ((base "/work/archive/")
       (target (han.path:absolute-pathname "tables/counts.tsv" base)))
  (han.path:->namestring (han.path:relative-path target base)))
;; => "tables/counts.tsv"
```

[`han.path:absolute-pathname`](absolute-pathname.md) · [`han.path:parent-directory-pathname`](parent-directory-pathname.md) · [Source · 源码](../../../path/core.lisp) · [Index · 索引](../README.md)
