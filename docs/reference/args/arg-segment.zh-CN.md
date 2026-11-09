# `han.args:arg-segment`

[English](arg-segment.md)

*结构类型*

## 语法

```text
han.args:arg-segment
(typep object 'han.args:arg-segment) → generalized-boolean
```

## 说明

一个槽内的 token 位置集合。默认槽存放顶层选项和位置参数，命名槽可以整段绑定。

## 示例

核对解析命名槽后所得分段记录的类型。

```lisp
(let ((segment
        (second (han.args:args-input-segments
                 (han.args:parse-args-input '("demo" "-v" "@filter:" "high" "low"))))))
  (typep segment 'han.args:arg-segment))
;; => t
```

按段所属的槽，把顶层参数和命名块分给不同处理流程。

```lisp
(let ((input (han.args:parse-args-input '("demo" "item" "@next:" "-q"))))
  (mapcar (lambda (item)
            (etypecase item
              (han.args:arg-segment
               (if (han.args:arg-segment-slot item) :delegate :parse-here))))
          (han.args:args-input-segments input)))
;; => (:parse-here :delegate)
```

[`han.args:arg-segment-p`](arg-segment-p.zh-CN.md) · [`han.args:make-arg-segment`](make-arg-segment.zh-CN.md) · [`han.args:parse-args-input`](parse-args-input.zh-CN.md) · [源码](../../../args/lexer.lisp) · [索引](../README.zh-CN.md)
