# `han.json:write-json-file`

*Function · 函数*

## Syntax · 语法

```text
(han.json:write-json-file path value &key (indent 2)) → path
```

## Description · 说明

Create missing parent directories and write the value to a UTF-8 file, superseding an existing destination. Return `path` as supplied. Formatting follows `write-json`. Serialization and file errors propagate, so a failed write can leave a partial destination. The example uses a UIOP temporary pathname.

创建缺少的父目录，并把值以 UTF-8 写入文件，目标已存在时会覆盖。返回调用方传入的 `path`。格式控制与 `write-json` 相同。序列化和文件错误会传出，失败时目标中可能已有部分内容。示例使用 UIOP 管理的临时路径。

## Examples · 示例

Write an array to a temporary destination and decode it again.

将数组写入临时目标文件，并重新读取。

```lisp
(uiop:with-temporary-file (:pathname path)
  (let ((result (han.json:write-json-file path (han.json:json-array 2 3) :indent nil)))
    (list (equal path result)
          (coerce (han.json:read-json-file path) 'list))))
;; => (T (2 3))
```

A second write replaces the previous document at the same temporary path.

对同一临时路径再次写入时，先前的文档会被替换。

```lisp
(uiop:with-temporary-file (:pathname path)
  (han.json:write-json-file path (han.json:json-array 1 2 3))
  (han.json:write-json-file path :null :indent nil)
  (han.host:with-open-utf8-file (in path)
    (read-line in)))
;; => "null"
```

[`write-json`](write-json.md) · [`read-json-file`](read-json-file.md) · [Source · 源码](../../../json/core.lisp#L502) · [Index · 索引](../README.md)
