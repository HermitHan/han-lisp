# `han.path:absolute-pathname`

*Function · 函数*

## Syntax · 语法

```text
(han.path:absolute-pathname x &optional (base (truename "."))) → pathname
```

## Description · 说明

Returns an absolute input as a pathname. Otherwise merges the input against the directory form of `base`, which defaults to the current directory. Supply an absolute base for an absolute result. It does not require the target to exist or resolve its symlinks.

绝对路径输入直接转为 pathname；相对路径则以 base 的目录形式为基准合并。默认基准是当前目录。显式传入基准时应使用绝对路径以得到绝对结果。此操作无需目标存在，也不解析目标的符号链接。

## Examples · 示例

Resolve a relative table path against a project directory.

以项目目录为基准，把表格文件的相对路径转成绝对路径。

```lisp
(han.path:->namestring (han.path:absolute-pathname "tables/stats.tsv" "/work/project"))
;; => "/work/project/tables/stats.tsv"
```

Preserve an absolute override even when the caller supplies a different base.

明确给出绝对目标时，保留该路径，即使另传了不同的基准目录。

```lisp
(han.path:->namestring (han.path:absolute-pathname "/shared/ref.fa" "/work/project"))
;; => "/shared/ref.fa"
```

Use the current working directory as the default base for a CLI input.

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

[`han.path:absolute-pathname-p`](absolute-pathname-p.md) · [`han.path:relative-path`](relative-path.md) · [`han.path:join-path`](join-path.md) · [Source · 源码](../../../path/core.lisp) · [Index · 索引](../README.md)
