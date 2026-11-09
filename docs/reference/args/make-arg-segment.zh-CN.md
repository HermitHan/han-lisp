# `han.args:make-arg-segment`

[English](make-arg-segment.md)

*构造器*

## 语法

```text
(han.args:make-arg-segment &key slot positions) → han.args:arg-segment
```

## 说明

根据给定的关键字字段创建并返回新的 `arg-segment` 对象。省略的字段默认为 `nil`。手工构造时，索引需要与同一输入对象的 token 向量相对应。

## 示例

构建引用两个 token 位置的命名段。

```lisp
(let ((segment
        (han.args:make-arg-segment
         :slot "filter" :positions '(2 3))))
  (han.args:arg-segment-slot segment))
;; => "filter"
```

创建一个含两个 token 索引的顶层段，省略槽名即可。

```lisp
(let ((segment (han.args:make-arg-segment :positions '(0 1))))
  (values (han.args:arg-segment-slot segment) (han.args:arg-segment-positions segment)))
;; => values (nil (0 1))
```

[`han.args:arg-segment`](arg-segment.zh-CN.md) · [`han.args:arg-segment-slot`](arg-segment-slot.zh-CN.md) · [`han.args:parse-args-input`](parse-args-input.zh-CN.md) · [源码](../../../args/lexer.lisp) · [索引](../README.zh-CN.md)
