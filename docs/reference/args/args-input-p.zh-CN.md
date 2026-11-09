# `han.args:args-input-p`

[English](args-input-p.md)

*谓词*

## 语法

```text
(han.args:args-input-p object) → generalized-boolean
```

## 说明

判断传入的 Lisp 对象是否为 `args-input` 结构。只检查对象类型，调用后对象保持原样。

## 示例

确认词法分析结果是完整的输入记录。再与无关关键字作对照。

```lisp
(let ((input (han.args:parse-args-input '("demo" "notes.txt" "@filter:" "--mode=fast"))))
  (list (han.args:args-input-p input) (han.args:args-input-p :unparsed)))
;; => (t nil)
```

库的入口可以复用已经解析过的参数。

```lisp
(flet ((ensure-input (value)
         (if (han.args:args-input-p value) value (han.args:parse-args-input value))))
  (let ((old (han.args:parse-args-input '("scan"))))
    (values (eq (ensure-input old) old)
            (han.args:args-input-raw-cmd (ensure-input '("pack"))))))
;; => values (t "pack")
```

[`han.args:args-input`](args-input.zh-CN.md) · [`han.args:parse-args-input`](parse-args-input.zh-CN.md) · [源码](../../../args/lexer.lisp) · [索引](../README.zh-CN.md)
