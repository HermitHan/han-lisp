# `han.args:arg-segment`

*Structure type · 结构类型*

## Syntax · 语法

```text
han.args:arg-segment
(typep object 'han.args:arg-segment) → generalized-boolean
```

## Description · 说明

A group of token positions in one slot. The default slot holds top-level options and positionals. Named slots can bind whole blocks.

一个槽内的 token 位置集合。默认槽存放顶层选项和位置参数，命名槽可以整段绑定。

## Examples · 示例

Check the type of a named group returned by the lexer. 核对解析命名槽后所得分段记录的类型。

```lisp
(let ((segment
        (second (han.args:args-input-segments
                 (han.args:parse-args-input '("demo" "-v" "@filter:" "high" "low"))))))
  (typep segment 'han.args:arg-segment))
;; => t
```

Dispatch a top-level segment and a named block to different handlers. 按段所属的槽，把顶层参数和命名块分给不同处理流程。

```lisp
(let ((input (han.args:parse-args-input '("demo" "item" "@next:" "-q"))))
  (mapcar (lambda (item)
            (etypecase item
              (han.args:arg-segment
               (if (han.args:arg-segment-slot item) :delegate :parse-here))))
          (han.args:args-input-segments input)))
;; => (:parse-here :delegate)
```

[`han.args:arg-segment-p`](arg-segment-p.md) · [`han.args:make-arg-segment`](make-arg-segment.md) · [`han.args:parse-args-input`](parse-args-input.md) · [Source · 源码](../../../args/lexer.lisp) · [Index · 索引](../README.md)
