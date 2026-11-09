# `han.source:source-span-from-source-p`

[English](source-span-from-source-p.md)

*谓词*

## 语法

```text
(han.source:source-span-from-source-p span source &optional (report-error nil)) → boolean
```

## 说明

判断区间是否由此字符源的标记构造。来源不同时默认返回假，将可选参数设为真则报错。原游标继续读取不会使区间失效。

## 示例

**在两个文本相同的游标中辨认区间的来源**

```lisp
(let* ((src (han.source:make-char-source "x"))
       (mark (han.source:make-source-mark src))
       (span (han.source:make-source-span mark mark)))
  (list (han.source:source-span-from-source-p span src)
        (han.source:source-span-from-source-p span (han.source:make-char-source "x"))))
;; => (T NIL)
```

**要求在区间来源不匹配时报告错误**

```lisp
(defparameter *span*
  (let* ((original (han.source:make-char-source "x"))
         (mark (han.source:make-source-mark original)))
    (han.source:make-source-span mark mark)))
(defparameter *other-cursor* (han.source:make-char-source "x"))
(han.source:source-span-from-source-p *span* *other-cursor* t)
;; signals simple-error
```

[`han.source:make-source-span`](make-source-span.zh-CN.md) · [`han.source:source-same-origin-p`](source-same-origin-p.zh-CN.md) · [`han.source:source-slice-by-span`](source-slice-by-span.zh-CN.md) · [源码](../../../source/char-source.lisp) · [索引](../README.zh-CN.md)
