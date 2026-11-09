# `han.source:char-source`

[English](char-source.md)

*结构类型*

## 语法

```text
han.source:char-source
```

## 说明

可移动文本游标的结构类型。每个游标保有自己的字符串、当前索引、行列和来源标识，回退或取区间时会核对来源。用 `make-char-source` 创建实例。

## 示例

**检查由字符串创建的游标是否为 `char-source` 类型**

```lisp
(typep (han.source:make-char-source "key=value") 'han.source:char-source)
;; => T
```

**按游标或字符串输入选择读取方式**

```lisp
(flet ((first-char (input)
         (etypecase input
           (han.source:char-source (han.source:source-peek-char input))
           (string (and (plusp (length input)) (char input 0))))))
  (mapcar #'first-char (list (han.source:make-char-source "8080") "tcp" "")))
;; => (#\8 #\t NIL)
```

[`han.source:make-char-source`](make-char-source.zh-CN.md) · [`han.source:char-source-p`](char-source-p.zh-CN.md) · [`han.source:source-location`](source-location.zh-CN.md) · [源码](../../../source/char-source.lisp) · [索引](../README.zh-CN.md)
