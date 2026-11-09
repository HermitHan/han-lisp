# `han.source:source-match-string-p`

[English](source-match-string-p.md)

*谓词*

## 语法

```text
(han.source:source-match-string-p source target) → boolean
```

## 说明

区分大小写地比较剩余文本是否以 `target` 开头，游标保持原位。剩余长度不足时返回假。空串在输入末尾也能匹配。

## 示例

**尝试匹配两种箭头拼法，随后查看首字符**

```lisp
(let ((src (han.source:make-char-source "->x")))
  (list (han.source:source-match-string-p src "->") (han.source:source-match-string-p src "-->")
        (han.source:source-peek-char src)))
;; => (T NIL #\-)
```

**在末尾区分空前缀和非空前缀**

```lisp
(let ((src (han.source:make-char-source "")))
  (values (han.source:source-match-string-p src "") (han.source:source-match-string-p src ":")))
;; => values (T NIL)
```

[`han.source:source-consume-string-if`](source-consume-string-if.zh-CN.md) · [`han.source:source-peek-string`](source-peek-string.zh-CN.md) · [源码](../../../source/char-source.lisp) · [索引](../README.zh-CN.md)
