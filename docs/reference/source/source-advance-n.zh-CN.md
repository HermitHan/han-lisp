# `han.source:source-advance-n`

[English](source-advance-n.md)

*函数*

## 语法

```text
(han.source:source-advance-n source n) → source
```

## 说明

最多消耗 `n` 个字符并返回原游标。使用非负计数，提前到达末尾也可以正常返回。遇到换行与逐次调用 `source-next-char` 一样会更新行列。

## 示例

**在只有两个字符的输入中请求前进十个字符，检查返回的游标和索引**

```lisp
(let ((src (han.source:make-char-source "xy")))
  (list (eq src (han.source:source-advance-n src 10)) (han.source:source-location src)))
;; => (T 2)
```

**跨换行推进后检查新坐标**

```lisp
(let ((src (han.source:make-char-source (format nil "x~%yz"))))
  (han.source:source-advance-n src 3)
  (han.source:source-location src))
;; => values (3 2 2)
```

[`han.source:source-next-char`](source-next-char.zh-CN.md) · [`han.source:source-location`](source-location.zh-CN.md) · [`han.source:source-eof-p`](source-eof-p.zh-CN.md) · [源码](../../../source/char-source.lisp) · [索引](../README.zh-CN.md)
