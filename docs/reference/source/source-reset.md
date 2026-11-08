# `han.source:source-reset`

*Function · 函数*

## Syntax · 语法

```text
(han.source:source-reset source mark) → source
```

## Description · 说明

Restores all three coordinates from `mark` and returns the same, now repositioned cursor. A mark captured from another source signals an error, including when both sources have equal text.

用标记恢复索引、行、列，返回已重新定位的原游标。即使文本相同，使用另一字符源的标记也会报错。

## Examples · 示例

**Rewind to the starting mark and read the first letter again · 退回起点标记并重新读取首字母**

```lisp
(let* ((src (han.source:make-char-source "abc"))
       (start (han.source:make-source-mark src)))
  (han.source:source-advance-n src 2)
  (han.source:source-reset src start)
  (han.source:source-next-char src))
;; => #\a
```

**Reject a checkpoint from an identical but separate input · 拒绝另一份相同输入保存的检查点**

```lisp
(defparameter *cursor* (han.source:make-char-source "abc"))
(defparameter *foreign-mark*
  (han.source:make-source-mark (han.source:make-char-source "abc")))
(han.source:source-reset *cursor* *foreign-mark*)
;; signals simple-error
```

**Restore line and column after speculative multiline reading · 试读跨行内容之后恢复行列坐标**

```lisp
(let* ((src (han.source:make-char-source (format nil "one~%two")))
       (begin (han.source:make-source-mark src)))
  (han.source:source-advance-n src 6)
  (han.source:source-location (han.source:source-reset src begin)))
;; => values (0 1 1)
```

[`han.source:make-source-mark`](make-source-mark.md) · [`han.source:source-location`](source-location.md) · [`han.source:source-mark-from-source-p`](source-mark-from-source-p.md) · [Source · 源码](../../../source/char-source.lisp) · [Index · 索引](../README.md)
