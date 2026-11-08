# `han.path:absolute-pathname-p`

*Predicate · 谓词*

## Syntax · 语法

```text
(han.path:absolute-pathname-p x) → boolean
```

## Description · 说明

Tests whether the pathname’s directory list begins with `:absolute`. The target need not exist. Use it when a caller accepts both relative and absolute names.

检查 pathname 的目录序列是否以 `:absolute` 开头。目标无需实际存在。程序既接受相对路径也接受绝对路径时可以据此分支。

## Examples · 示例

Compare an absolute Unix path with a relative file name.

分别判断一个 Unix 绝对路径和一个相对文件名。

```lisp
(list (han.path:absolute-pathname-p "/work/a") (han.path:absolute-pathname-p "a"))
;; => (T NIL)
```

Decide whether an input should be resolved against a project root.

据此决定是否需要按项目根目录解释输入路径。

```lisp
(let ((base "/work/project"))
  (mapcar (lambda (input)
            (han.path:->namestring
             (if (han.path:absolute-pathname-p input)
                 input
                 (han.path:join-path base input))))
          '("data/raw.tsv" "/shared/ref.tsv")))
;; => ("/work/project/data/raw.tsv" "/shared/ref.tsv")
```

[`han.path:absolute-pathname`](absolute-pathname.md) · [`han.path:relative-path`](relative-path.md) · [Source · 源码](../../../path/core.lisp) · [Index · 索引](../README.md)
