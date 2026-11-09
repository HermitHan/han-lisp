# `han.path:absolute-pathname`

[English](absolute-pathname.md)

*函数*

## 语法

```text
(han.path:absolute-pathname x &optional base) → pathname
```

## 说明

绝对路径输入直接转为 pathname；相对路径则以 base 的目录形式为基准合并。默认基准是当前目录。显式传入基准时应使用绝对路径以得到绝对结果。此操作无需目标存在，也不解析目标的符号链接。

## 示例

以项目目录为基准，把表格文件的相对路径转成绝对路径。

```lisp
(han.path:->namestring (han.path:absolute-pathname "tables/stats.tsv" "/work/project"))
;; => "/work/project/tables/stats.tsv"
```

明确给出绝对目标时，保留该路径，即使另传了不同的基准目录。

```lisp
(han.path:->namestring (han.path:absolute-pathname "/shared/ref.fa" "/work/project"))
;; => "/shared/ref.fa"
```

处理 CLI 相对输入时使用当前工作目录作为默认基准。

```lisp
(let ((root (uiop:ensure-directory-pathname (uiop:run-program '("mktemp" "-d") :output :line))))
  (unwind-protect
       (uiop:with-current-directory (root)
         (equal (han.path:absolute-pathname "next.json")
                (merge-pathnames "next.json" (truename root))))
    (uiop:delete-directory-tree root :validate t :if-does-not-exist :ignore)))
;; => T
```

[`han.path:absolute-pathname-p`](absolute-pathname-p.zh-CN.md) · [`han.path:relative-path`](relative-path.zh-CN.md) · [`han.path:join-path`](join-path.zh-CN.md) · [源码](../../../path/core.lisp) · [索引](../README.zh-CN.md)
