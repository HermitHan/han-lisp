# `han.args:args-input-p`

*Predicate · 谓词*

## Syntax · 语法

```text
(han.args:args-input-p object) → generalized-boolean
```

## Description · 说明

Recognize a `args-input` structure. Any Lisp object can be passed. The predicate inspects its type without changing it.

判断传入的 Lisp 对象是否为 `args-input` 结构。只检查对象类型，调用后对象保持原样。

## Examples · 示例

Recognize the object representing a complete invocation. Compare it with an unrelated keyword. 确认词法分析结果是完整的输入记录。再与无关关键字作对照。

```lisp
(let ((input (han.args:parse-args-input '("demo" "notes.txt" "@filter:" "--mode=fast"))))
  (list (han.args:args-input-p input) (han.args:args-input-p :unparsed)))
;; => (t nil)
```

Reuse already parsed arguments at a library boundary. 库的入口可以复用已经解析过的参数。

```lisp
(flet ((ensure-input (value)
         (if (han.args:args-input-p value) value (han.args:parse-args-input value))))
  (let ((old (han.args:parse-args-input '("scan"))))
    (values (eq (ensure-input old) old)
            (han.args:args-input-raw-cmd (ensure-input '("pack"))))))
;; => values (t "pack")
```

[`han.args:args-input`](args-input.md) · [`han.args:parse-args-input`](parse-args-input.md) · [Source · 源码](../../../args/lexer.lisp) · [Index · 索引](../README.md)
