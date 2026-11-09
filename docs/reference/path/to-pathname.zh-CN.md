# `han.path:->pathname`

[English](to-pathname.md)

*函数*

## 语法

```text
(han.path:->pathname x) → pathname
```

## 说明

接受字符串或 pathname。字符串按当前 Lisp 实现的 namestring 语法解析。缺少目录分量时按相对路径处理，已有的目录分量保留其宿主表示，包括通配符。所指文件可以尚不存在。

## 示例

将相对路径字符串转成 pathname，再分别查看文件名、类型与目录分量。

```lisp
(let ((file (han.path:->pathname "runs/report.json")))
  (list (pathname-name file) (pathname-type file) (pathname-directory file)))
;; => ("report" "json" (:RELATIVE "runs"))
```

传入 pathname 而非字符串，核对目录形式经过统一转换后仍保留。

```lisp
(let* ((directory #P"/tmp/project/")
       (converted (han.path:->pathname directory)))
  (list (pathnamep converted) (han.path:directory-pathname-p converted)
        (pathname-name converted)))
;; => (T T NIL)
```

[`han.path:->namestring`](to-namestring.zh-CN.md) · [`han.path:directory-pathname`](directory-pathname.zh-CN.md) · [`han.path:join-path`](join-path.zh-CN.md) · [源码](../../../path/core.lisp) · [索引](../README.zh-CN.md)
