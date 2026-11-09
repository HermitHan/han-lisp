# `han.args:arg-spec-p`

[English](arg-spec-p.md)

*谓词*

## 语法

```text
(han.args:arg-spec-p object) → generalized-boolean
```

## 说明

判断传入的 Lisp 对象是否为 `arg-spec` 结构。只检查对象类型，调用后对象保持原样。

## 示例

确认选项声明解析后的类型。再与无关关键字作对照。

```lisp
(let ((spec (han.args:parse-arg-spec "!(--/-j)jobs")))
  (list (han.args:arg-spec-p spec) (han.args:arg-spec-p :unparsed)))
;; => (t nil)
```

批量接收字符串或规格，已解析的元素可以原样复用。

```lisp
(let ((entries (list "a=1" (han.args:parse-arg-spec "b=2"))))
  (mapcar (lambda (x)
            (han.args:arg-spec-default
             (if (han.args:arg-spec-p x) x (han.args:parse-arg-spec x))))
          entries))
;; => ("1" "2")
```

[`han.args:arg-spec`](arg-spec.zh-CN.md) · [`han.args:parse-arg-spec`](parse-arg-spec.zh-CN.md) · [源码](../../../args/spec.lisp) · [索引](../README.zh-CN.md)
