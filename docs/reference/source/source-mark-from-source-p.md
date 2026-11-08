# `han.source:source-mark-from-source-p`

*Predicate · 谓词*

## Syntax · 语法

```text
(han.source:source-mark-from-source-p mark source &optional (report-error nil)) → boolean
```

## Description · 说明

Compares the identity stored in `mark` with that of `source`. A mismatch returns false by default and signals an error when `report-error` is true. Comparing the input strings alone cannot establish ownership.

检查标记和游标的来源标识。来源不同时默认返回假，将 `report-error` 设为真会发出错误。两份字符源即使文本相同也有各自的标记。

## Examples · 示例

**Test a mark against two cursors initialized with the same text · 用文本相同的两个游标检查标记的来源**

```lisp
(let* ((a (han.source:make-char-source "id"))
       (b (han.source:make-char-source "id"))
       (mark (han.source:make-source-mark a)))
  (list (han.source:source-mark-from-source-p mark a)
        (han.source:source-mark-from-source-p mark b)))
;; => (T NIL)
```

**Signal a foreign mark when validating parser input · 校验解析器输入时让外来源标记直接报错**

```lisp
(defparameter *mark*
  (han.source:make-source-mark (han.source:make-char-source "id")))
(defparameter *cursor* (han.source:make-char-source "id"))
(han.source:source-mark-from-source-p *mark* *cursor* t)
;; signals simple-error
```

[`han.source:make-source-mark`](make-source-mark.md) · [`han.source:source-same-origin-p`](source-same-origin-p.md) · [`han.source:source-reset`](source-reset.md) · [Source · 源码](../../../source/char-source.lisp) · [Index · 索引](../README.md)
