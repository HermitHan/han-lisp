# `han.path:absolute-pathname-p`

[English](absolute-pathname-p.md)

*谓词*

## 语法

```text
(han.path:absolute-pathname-p x) → boolean
```

## 说明

能识别以 `:absolute` 开头的目录列表、由字符串表示的顶层目录，以及仅为 `:wild` 的目录分量。判断只读取 pathname 的分量，无需访问文件系统。

## 示例

分别判断一个 Unix 绝对路径和一个相对文件名。

```lisp
(list (han.path:absolute-pathname-p "/work/a") (han.path:absolute-pathname-p "a"))
;; => (T NIL)
```

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

[`han.path:absolute-pathname`](absolute-pathname.zh-CN.md) · [`han.path:relative-path`](relative-path.zh-CN.md) · [源码](../../../path/core.lisp) · [索引](../README.zh-CN.md)
