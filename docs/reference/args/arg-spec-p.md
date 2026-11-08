# `han.args:arg-spec-p`

*Predicate · 谓词*

## Syntax · 语法

```text
(han.args:arg-spec-p object) → generalized-boolean
```

## Description · 说明

Recognize a `arg-spec` structure. Any Lisp object can be passed. The predicate inspects its type without changing it.

判断传入的 Lisp 对象是否为 `arg-spec` 结构。只检查对象类型，调用后对象保持原样。

## Examples · 示例

Recognize a parsed option declaration. Compare it with an unrelated keyword. 确认选项声明解析后的类型。再与无关关键字作对照。

```lisp
(let ((spec (han.args:parse-arg-spec "!(--/-j)jobs")))
  (list (han.args:arg-spec-p spec) (han.args:arg-spec-p :unparsed)))
;; => (t nil)
```

Convert strings into declarations exactly once. 批量接收字符串或规格，已解析的元素可以原样复用。

```lisp
(let ((entries (list "a=1" (han.args:parse-arg-spec "b=2"))))
  (mapcar (lambda (x)
            (han.args:arg-spec-default
             (if (han.args:arg-spec-p x) x (han.args:parse-arg-spec x))))
          entries))
;; => ("1" "2")
```

[`han.args:arg-spec`](arg-spec.md) · [`han.args:parse-arg-spec`](parse-arg-spec.md) · [Source · 源码](../../../args/spec.lisp) · [Index · 索引](../README.md)
