# `han.args:arg-segment-p`

*Predicate · 谓词*

## Syntax · 语法

```text
(han.args:arg-segment-p object) → generalized-boolean
```

## Description · 说明

Recognize a `arg-segment` structure. Any Lisp object can be passed. The predicate inspects its type without changing it.

判断传入的 Lisp 对象是否为 `arg-segment` 结构。只检查对象类型，调用后对象保持原样。

## Examples · 示例

Recognize a named group returned by the lexer. Compare it with an unrelated keyword. 核对解析命名槽后所得分段记录的类型。再与无关关键字作对照。

```lisp
(let ((segment
        (second (han.args:args-input-segments
                 (han.args:parse-args-input '("demo" "-v" "@filter:" "high" "low"))))))
  (list (han.args:arg-segment-p segment) (han.args:arg-segment-p :unparsed)))
;; => (t nil)
```

Read slot names from selected parse records. 从混合解析记录中筛出段并读取槽名。

```lisp
(let* ((input (han.args:parse-args-input '("demo" "@a:" "q")))
       (items (cons input (han.args:args-input-segments input))))
  (mapcar #'han.args:arg-segment-slot (remove-if-not #'han.args:arg-segment-p items)))
;; => (nil "a")
```

[`han.args:arg-segment`](arg-segment.md) · [`han.args:parse-args-input`](parse-args-input.md) · [Source · 源码](../../../args/lexer.lisp) · [Index · 索引](../README.md)
