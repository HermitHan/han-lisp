# `han.args:make-args-input`

[English](make-args-input.md)

*构造器*

## 语法

```text
(han.args:make-args-input &key raw-cmd raw-argv tokens segments diagnostics) → han.args:args-input
```

## 说明

根据给定的关键字字段创建并返回新的 `args-input` 对象。省略的字段默认为 `nil`。提供普通 argv 时，可用解析器一次构建 token 向量与对应的段索引。

## 示例

手工构造只包含命令名的输入。

```lisp
(let ((input
        (han.args:make-args-input
         :raw-cmd "demo" :raw-argv nil :tokens #() :segments nil :diagnostics nil)))
  (han.args:args-input-raw-cmd input))
;; => "demo"
```

为自建位置 token 提供段索引，再用同一个绑定器查询它。

```lisp
(let* ((token (han.args:make-arg-token :kind :value :text "x" :value "x" :position 0))
       (segment (han.args:make-arg-segment :positions '(0)))
       (input (han.args:make-args-input :raw-cmd "demo" :raw-argv '("x")
                                        :tokens (vector token) :segments (list segment)))
       (schema (han.args:parse-args-spec (list (han.args:parse-arg-spec "$1")))))
  (han.args:get-arg 1 (han.args:bind-args schema input)))
;; => values ("x" :input)
```

[`han.args:args-input`](args-input.zh-CN.md) · [`han.args:args-input-raw-cmd`](args-input-raw-cmd.zh-CN.md) · [`han.args:parse-args-input`](parse-args-input.zh-CN.md) · [源码](../../../args/lexer.lisp) · [索引](../README.zh-CN.md)
