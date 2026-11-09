# `han.path:directory-pathname`

[English](directory-pathname.md)

*函数*

## 语法

```text
(han.path:directory-pathname x) → directory-pathname
```

## 说明

接受字符串或 pathname。若最后一段是文件名，就把包括扩展名在内的这一段作为目录分量；目录形式的输入仍返回目录 pathname。此操作仅变换路径，不创建目录。

## 示例

将 `draft.v2` 作为目录处理，保留目录名中的点。

```lisp
(han.path:->namestring (han.path:directory-pathname "draft.v2"))
;; => "draft.v2/"
```

统一有无末尾斜杠的目录输入，使两种拼写产生同一目录 pathname。

```lisp
(equal (han.path:directory-pathname "/work/reports")
       (han.path:directory-pathname #P"/work/reports/"))
;; => T
```

[`han.path:parent-directory-pathname`](parent-directory-pathname.zh-CN.md) · [`han.path:directory-pathname-p`](directory-pathname-p.zh-CN.md) · [`han.path:join-path`](join-path.zh-CN.md) · [源码](../../../path/core.lisp) · [索引](../README.zh-CN.md)
