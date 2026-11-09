# `han.source:source-same-origin-p`

[English](source-same-origin-p.md)

*谓词*

## 语法

```text
(han.source:source-same-origin-p target &rest others) → boolean
```

## 说明

比较任意组合的游标、标记、区间的来源。仅传一个有效对象返回真。它核对构造时分配的标识，参数类型限于这三种。

## 示例

**检查游标、由它保存的标记和据此创建的空区间是否同源**

```lisp
(let* ((src (han.source:make-char-source "ab"))
       (mark (han.source:make-source-mark src))
       (span (han.source:make-source-span mark mark)))
  (han.source:source-same-origin-p src mark span))
;; => T
```

**比较分别解析同一文本所得的区间**

```lisp
(flet ((empty-span (src)
         (let ((m (han.source:make-source-mark src))) (han.source:make-source-span m m))))
  (han.source:source-same-origin-p (empty-span (han.source:make-char-source "x"))
                         (empty-span (han.source:make-char-source "x"))))
;; => NIL
```

[`han.source:source-mark-from-source-p`](source-mark-from-source-p.zh-CN.md) · [`han.source:source-span-from-source-p`](source-span-from-source-p.zh-CN.md) · [源码](../../../source/char-source.lisp) · [索引](../README.zh-CN.md)
