# `han.source:source-reset`

[English](source-reset.md)

*函数*

## 语法

```text
(han.source:source-reset source mark) → source
```

## 说明

用标记恢复索引、行、列，返回已重新定位的原游标。即使文本相同，使用另一字符源的标记也会报错。

## 示例

**退回起点标记并重新读取首字母**

```lisp
(let* ((src (han.source:make-char-source "abc"))
       (start (han.source:make-source-mark src)))
  (han.source:source-advance-n src 2)
  (han.source:source-reset src start)
  (han.source:source-next-char src))
;; => #\a
```

**拒绝另一份相同输入保存的检查点**

```lisp
(defparameter *cursor* (han.source:make-char-source "abc"))
(defparameter *foreign-mark*
  (han.source:make-source-mark (han.source:make-char-source "abc")))
(han.source:source-reset *cursor* *foreign-mark*)
;; signals simple-error
```

**试读跨行内容之后恢复行列坐标**

```lisp
(let* ((src (han.source:make-char-source (format nil "one~%two")))
       (begin (han.source:make-source-mark src)))
  (han.source:source-advance-n src 6)
  (han.source:source-location (han.source:source-reset src begin)))
;; => values (0 1 1)
```

[`han.source:make-source-mark`](make-source-mark.zh-CN.md) · [`han.source:source-location`](source-location.zh-CN.md) · [`han.source:source-mark-from-source-p`](source-mark-from-source-p.zh-CN.md) · [源码](../../../source/char-source.lisp) · [索引](../README.zh-CN.md)
