# `han.args:arg-token-value`

*Accessor · 访问器*

## Syntax · 语法

```text
(han.args:arg-token-value token) → string or nil
(setf (han.args:arg-token-value token) new-value) → new-value
```

## Description · 说明

Return the normalized token value. An option yields the name without dashes or attached value, a named slot yields its name, and an ordinary value yields its text. The switch `@:` has value `nil`.

返回 token 的规范化值。选项返回去掉前导短横线和附加值的名称，命名槽返回槽名，普通值返回原文。切回顶层的 `@:` 对应 `nil`。

## Examples · 示例

Read the lookup name from an attached option. 从带内联值的选项取得名称。

```lisp
(let ((token
        (aref (han.args:args-input-tokens
               (han.args:parse-args-input '("demo" "--jobs=4")))
              0)))
  (han.args:arg-token-value token))
;; => "jobs"
```

Read the markers for entering a slot and returning to the top level. 查看进入命名槽和返回顶层时标记所携带的值。

```lisp
(let ((input
        (han.args:parse-args-input '("demo" "@files:" "a.txt" "@:"))))
  (map 'list #'han.args:arg-token-value (han.args:args-input-tokens input)))
;; => ("files" "a.txt" nil)
```

[`han.args:arg-token`](arg-token.md) · [`han.args:parse-args-input`](parse-args-input.md) · [Source · 源码](../../../args/lexer.lisp) · [Index · 索引](../README.md)
