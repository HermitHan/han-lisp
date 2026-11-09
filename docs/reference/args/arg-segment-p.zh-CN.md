# `han.args:arg-segment-p`

[English](arg-segment-p.md)

*谓词*

## 语法

```text
(han.args:arg-segment-p object) → generalized-boolean
```

## 说明

判断传入的 Lisp 对象是否为 `arg-segment` 结构。只检查对象类型，调用后对象保持原样。

## 示例

核对解析命名槽后所得分段记录的类型。再与无关关键字作对照。

```lisp
(let ((segment
        (second (han.args:args-input-segments
                 (han.args:parse-args-input '("demo" "-v" "@filter:" "high" "low"))))))
  (list (han.args:arg-segment-p segment) (han.args:arg-segment-p :unparsed)))
;; => (t nil)
```

从混合解析记录中筛出段并读取槽名。

```lisp
(let* ((input (han.args:parse-args-input '("demo" "@a:" "q")))
       (items (cons input (han.args:args-input-segments input))))
  (mapcar #'han.args:arg-segment-slot (remove-if-not #'han.args:arg-segment-p items)))
;; => (nil "a")
```

[`han.args:arg-segment`](arg-segment.zh-CN.md) · [`han.args:parse-args-input`](parse-args-input.zh-CN.md) · [源码](../../../args/lexer.lisp) · [索引](../README.zh-CN.md)
