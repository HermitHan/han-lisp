# `han.host:with-character-output-to-string`

*Macro · 宏*

## Syntax · 语法

```text
(han.host:with-character-output-to-string (stream) &body body) → string
```

## Description · 说明

Binds `stream` to a character output stream for the body and returns the collected string. The backing buffer has element type `character`, so non-ASCII text can coexist with ASCII even when the implementation normally chooses a narrower string.

在 body 内把 `stream` 绑定到字符输出流，返回写入内容构成的字符串。缓冲区元素类型为 `character`，可以在默认选择较窄字符串的实现上同时保留 ASCII 和非 ASCII 文本。

## Examples · 示例

Collect Chinese text and a single Latin letter in the same string.

将中文文本与一个拉丁字母写入同一个字符串。

```lisp
(han.host:with-character-output-to-string (out)
  (write-string "路径/" out)
  (write-char #\A out))
;; => "路径/A"
```

Render a sequence of records through an ordinary stream-writing function.

把多条记录交给普通的流输出函数，在内存中组装完整文本。

```lisp
(let ((text (han.host:with-character-output-to-string (out)
              (dolist (field '("id" "值"))
                (write-line field out)))))
  (with-input-from-string (in text)
    (han.os:load-lines in)))
;; => ("id" "值")
```

[`han.host:prepare-runtime-io`](prepare-runtime-io.md) · [`han.host:append-utf8-line`](append-utf8-line.md) · [common.lisp](../../../host/common.lisp) · [Index · 索引](../README.md)
