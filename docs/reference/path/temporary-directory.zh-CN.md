# `han.path:temporary-directory`

[English](temporary-directory.md)

*函数*

## 语法

```text
(han.path:temporary-directory) → directory-pathname
```

## 说明

按 `TMPDIR`、`TEMP`、`TMP` 的顺序选择临时目录，最后回退到 `/tmp/`，返回目录 pathname。创建临时文件时由调用方选择唯一的子路径。此函数只返回路径。

## 示例

检查临时目录的返回值是否是目录形式的 pathname。

```lisp
(han.path:directory-pathname-p (han.path:temporary-directory))
;; => T
```

使用选定的临时根目录构造绝对暂存文件名，无需创建文件。

```lisp
(let* ((dir (han.path:absolute-pathname (han.path:temporary-directory)))
       (output (han.path:join-path dir "stage" "table.tsv")))
  (han.path:->namestring (han.path:relative-path output dir)))
;; => "stage/table.tsv"
```

在选定目录内预留临时文件，并核对实际磁盘位置。

```lisp
(uiop:with-temporary-file (:directory (han.path:temporary-directory) :pathname file)
  (string= (namestring (truename (han.path:parent-directory-pathname file)))
           (namestring (truename (han.path:temporary-directory)))))
;; => T
```

[`han.path:directory-pathname`](directory-pathname.zh-CN.md) · [`han.path:join-path`](join-path.zh-CN.md) · [`han.host:temporary-directory`](../host/temporary-directory.zh-CN.md) · [源码](../../../path/core.lisp) · [索引](../README.zh-CN.md)
