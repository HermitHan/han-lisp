# `han.path:join-path`

*Function · 函数*

## Syntax · 语法

```text
(han.path:join-path base &rest parts) → pathname
```

## Description · 说明

Merges the parts from left to right. Each intermediate result acts as a directory for the next part. With no parts it returns the base as a pathname. An absolute child can replace the preceding directory.

从左向右合并各段，每一段中间结果都会作为下一段的目录基准。没有后续分段时只将 base 转为 pathname。绝对路径分段可以替换之前拼出的目录。

## Examples · 示例

Build the path to a sample’s configuration file from four components.

用四个路径分量拼出样本配置文件的位置。

```lisp
(han.path:->namestring (han.path:join-path "/work" "samples" "S01" "config.json"))
;; => "/work/samples/S01/config.json"
```

Respect an explicitly absolute component supplied by a caller.

调用方显式传入绝对路径分量时，从该路径继续拼接。

```lisp
(han.path:->namestring (han.path:join-path "/project/" "cache" "/shared/" "x.dat"))
;; => "/shared/x.dat"
```

Keep a relative base relative while inserting a dotted intermediate directory.

使用相对基准并插入带点的中间目录名，结果仍是相对路径。

```lisp
(let ((file (han.path:join-path "results" "run.v2" "summary.tsv")))
  (list (han.path:absolute-pathname-p file) (han.path:->namestring file)))
;; => (NIL "results/run.v2/summary.tsv")
```

[`han.path:directory-pathname`](directory-pathname.md) · [`han.path:absolute-pathname`](absolute-pathname.md) · [`han.path:->namestring`](to-namestring.md) · [Source · 源码](../../../path/core.lisp) · [Index · 索引](../README.md)
