# `han.path:temporary-directory`

*Function · 函数*

## Syntax · 语法

```text
(han.path:temporary-directory) → directory-pathname
```

## Description · 说明

Returns a directory pathname chosen from the environment in order: `TMPDIR`, `TEMP`, `TMP`, then `/tmp/`. The caller chooses a fresh child name for each temporary file. This function does not create a directory.

按 `TMPDIR`、`TEMP`、`TMP` 的顺序选择临时目录，最后回退到 `/tmp/`，返回目录 pathname。创建临时文件时由调用方选择唯一的子路径。此函数只返回路径。

## Examples · 示例

Check that the temporary directory is returned as a directory pathname.

检查临时目录的返回值是否是目录形式的 pathname。

```lisp
(han.path:directory-pathname-p (han.path:temporary-directory))
;; => T
```

Build an absolute scratch filename underneath the selected temporary root without creating it.

使用选定的临时根目录构造绝对暂存文件名，无需创建文件。

```lisp
(let* ((dir (han.path:absolute-pathname (han.path:temporary-directory)))
       (output (han.path:join-path dir "stage" "table.tsv")))
  (han.path:->namestring (han.path:relative-path output dir)))
;; => "stage/table.tsv"
```

Reserve a file under the chosen directory and verify the filesystem location.

在选定目录内预留临时文件，并核对实际磁盘位置。

```lisp
(uiop:with-temporary-file (:directory (han.path:temporary-directory) :pathname file)
  (equal (truename (han.path:parent-directory-pathname file))
         (truename (han.path:temporary-directory))))
;; => T
```

[`han.path:directory-pathname`](directory-pathname.md) · [`han.path:join-path`](join-path.md) · [`han.host:temporary-directory`](../host/temporary-directory.md) · [Source · 源码](../../../path/core.lisp) · [Index · 索引](../README.md)
