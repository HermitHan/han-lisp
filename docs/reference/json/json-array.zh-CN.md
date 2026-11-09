# `han.json:json-array`

[English](json-array.md)

*函数*

## 语法

```text
(han.json:json-array &rest values) → vector
```

## 说明

按传入顺序把各值组成向量。没有参数时结果表示 `[]`。元素若是 Lisp 的 `nil`，编码到 JSON 时写作 `false`。构造器允许传入 Lisp 对象，编码器在输出时检查它们能否写入 JSON。

## 示例

在同一行保存字符串、假值和空值。

```lisp
(let ((row (han.json:json-array "read" nil :null)))
  (list (aref row 0) (han.json:encode-json row :indent nil)))
;; => ("read" "[\"read\",false,null]")
```

空集合与值为假的开关会编码为不同文本。

```lisp
(mapcar (lambda (value) (han.json:encode-json value :indent nil))
        (list (han.json:json-array) nil))
;; => ("[]" "false")
```

[`json-array-p`](json-array-p.zh-CN.md) · [`encode-json`](encode-json.zh-CN.md) · [源码](../../../json/core.lisp#L24) · [索引](../README.zh-CN.md)
