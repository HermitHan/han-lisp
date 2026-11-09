# `han.source:source-skip-while`

[English](source-skip-while.md)

*函数*

## 语法

```text
(han.source:source-skip-while source predicate) → source
```

## 说明

依次把下一个字符交给谓词，为真时推进。遇到第一个不满足条件的字符就停在它之前，返回原游标。到末尾时不会再调用谓词。

## 示例

**跳过开头的空格并查看名称的首字符**

```lisp
(let ((src (han.source:make-char-source "   name")))
  (han.source:source-skip-while src (lambda (ch) (char= ch #\Space)))
  (han.source:source-peek-char src))
;; => #\n
```

**跳过空白，跨越换行直到输入末尾**

```lisp
(let ((src (han.source:make-char-source (format nil " ~% "))))
  (han.source:source-skip-while src (lambda (ch) (member ch '(#\Space #\Newline))))
  (han.source:source-location src))
;; => values (3 2 2)
```

[`han.source:source-read-while`](source-read-while.zh-CN.md) · [`han.source:source-peek-char`](source-peek-char.zh-CN.md) · [源码](../../../source/char-source.lisp) · [索引](../README.zh-CN.md)
