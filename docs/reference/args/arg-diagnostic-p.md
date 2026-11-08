# `han.args:arg-diagnostic-p`

*Predicate · 谓词*

## Syntax · 语法

```text
(han.args:arg-diagnostic-p object) → generalized-boolean
```

## Description · 说明

Recognize a `arg-diagnostic` structure. Any Lisp object can be passed. The predicate inspects its type without changing it.

判断传入的 Lisp 对象是否为 `arg-diagnostic` 结构。只检查对象类型，调用后对象保持原样。

## Examples · 示例

Recognize the record generated for a token spelling warning. Compare it with an unrelated keyword. 核对可疑 token 写法所产生的诊断记录类型。再与无关关键字作对照。

```lisp
(let ((diagnostic
        (first (han.args:args-input-diagnostics
                (han.args:parse-args-input '("demo" "--"))))))
  (list (han.args:arg-diagnostic-p diagnostic) (han.args:arg-diagnostic-p :unparsed)))
;; => (t nil)
```

Separate reported warnings from application events. 在事件列表中只收集解析诊断的严重程度。

```lisp
(let ((items (list :started (han.args:make-arg-diagnostic :kind :warning)
                   "message" (han.args:make-arg-diagnostic :kind :error))))
  (mapcar #'han.args:arg-diagnostic-kind
          (remove-if-not #'han.args:arg-diagnostic-p items)))
;; => (:warning :error)
```

[`han.args:arg-diagnostic`](arg-diagnostic.md) · [`han.args:args-result-diagnostics`](args-result-diagnostics.md) · [Source · 源码](../../../args/lexer.lisp) · [Index · 索引](../README.md)
