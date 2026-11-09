# `han.source:char-source-string`

[English](char-source-string.md)

*访问器*

## 语法

```text
(han.source:char-source-string source) → string
(setf (han.source:char-source-string source) new-value) → new-value
```

## 说明

返回游标持有的整段字符串，包括已经读过的部分。读取此槽不会复制字符串。创建游标后宜按只读方式使用，以便旧标记仍对应原来的文本。 结构体生成的写入器只更新这一个槽。需要更换输入文本并初始化坐标时，应创建新的字符源。

## 示例

**越过冒号后仍能取回完整输入**

```lisp
(let ((src (han.source:make-char-source "alpha:beta")))
  (han.source:source-advance-n src 6)
  (han.source:char-source-string src))
;; => "alpha:beta"
```

**由同一输入创建的两个游标分别持有副本**

```lisp
(let* ((input (copy-seq "AC"))
       (a (han.source:make-char-source input))
       (b (han.source:make-char-source input)))
  (list (string= (han.source:char-source-string a) (han.source:char-source-string b))
        (eq (han.source:char-source-string a) (han.source:char-source-string b))))
;; => (T NIL)
```

[`han.source:make-char-source`](make-char-source.zh-CN.md) · [`han.source:source-slice`](source-slice.zh-CN.md) · [`han.source:char-source-length`](char-source-length.zh-CN.md) · [源码](../../../source/char-source.lisp) · [索引](../README.zh-CN.md)
