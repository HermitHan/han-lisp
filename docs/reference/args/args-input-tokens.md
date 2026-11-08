# `han.args:args-input-tokens`

*Accessor · 访问器*

## Syntax · 语法

```text
(han.args:args-input-tokens input) → vector
(setf (han.args:args-input-tokens input) new-value) → new-value
```

## Description · 说明

Return the vector of `arg-token` records, in argv order, including slot switches. Use `aref` with a token position or an index from `arg-segment-positions`.

返回按 argv 顺序排列的 `arg-token` 向量，其中包含槽切换标记。可以用 token 位置或 `arg-segment-positions` 中的索引调用 `aref`。

## Examples · 示例

Inspect token kinds in argv order. 按输入顺序观察各个 token 的类别。

```lisp
(let ((input (han.args:parse-args-input '("demo" "notes.txt" "@filter:" "--mode=fast"))))
  (map 'list #'han.args:arg-token-kind (han.args:args-input-tokens input)))
;; => (:value :slot-switch :long-option)
```

Inspect an invocation with no arguments. 仅传入命令名时，token 向量可直接按空序列处理。

```lisp
(let ((input
        (han.args:parse-args-input '("demo"))))
  (values (vectorp (han.args:args-input-tokens input))
          (length (han.args:args-input-tokens input))))
;; => values (t 0)
```

[`han.args:args-input`](args-input.md) · [`han.args:parse-args-input`](parse-args-input.md) · [Source · 源码](../../../args/lexer.lisp) · [Index · 索引](../README.md)
