# `han.path:->pathname`

*Function · 函数*

## Syntax · 语法

```text
(han.path:->pathname x) → pathname
```

## Description · 说明

Accepts a string or pathname and constructs a pathname from its components. A missing directory component becomes relative. Strings use the Lisp implementation’s namestring syntax. The path can describe a file that does not yet exist.

接受字符串或 pathname，按其各个部分构造 pathname。缺少目录部分时按相对路径处理。字符串按当前 Lisp 实现的 namestring 语法解析，所指文件可以尚不存在。

## Examples · 示例

Convert a relative path string and inspect its file name, type and directory components.

将相对路径字符串转成 pathname，再分别查看文件名、类型与目录分量。

```lisp
(let ((file (han.path:->pathname "runs/report.json")))
  (list (pathname-name file) (pathname-type file) (pathname-directory file)))
;; => ("report" "json" (:RELATIVE "runs"))
```

Feed a directory pathname through a caller that accepts both strings and pathnames, and retain its directory shape.

传入 pathname 而非字符串，核对目录形式经过统一转换后仍保留。

```lisp
(let* ((directory #P"/tmp/project/")
       (converted (han.path:->pathname directory)))
  (list (pathnamep converted) (han.path:directory-pathname-p converted)
        (pathname-name converted)))
;; => (T T NIL)
```

[`han.path:->namestring`](to-namestring.md) · [`han.path:directory-pathname`](directory-pathname.md) · [`han.path:join-path`](join-path.md) · [Source · 源码](../../../path/core.lisp) · [Index · 索引](../README.md)
