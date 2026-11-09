# `han.args:arg-token-value`

[English](arg-token-value.md)

*访问器*

## 语法

```text
(han.args:arg-token-value token) → string or nil
(setf (han.args:arg-token-value token) new-value) → new-value
```

## 说明

返回 token 的规范化值。选项返回去掉前导短横线和附加值的名称，命名槽返回槽名，普通值返回原文。切回顶层的 `@:` 对应 `nil`。

## 示例

从带内联值的选项取得名称。

```lisp
(let ((token
        (aref (han.args:args-input-tokens
               (han.args:parse-args-input '("demo" "--jobs=4")))
              0)))
  (han.args:arg-token-value token))
;; => "jobs"
```

查看进入命名槽和返回顶层时标记所携带的值。

```lisp
(let ((input
        (han.args:parse-args-input '("demo" "@files:" "a.txt" "@:"))))
  (map 'list #'han.args:arg-token-value (han.args:args-input-tokens input)))
;; => ("files" "a.txt" nil)
```

[`han.args:arg-token`](arg-token.zh-CN.md) · [`han.args:parse-args-input`](parse-args-input.zh-CN.md) · [源码](../../../args/lexer.lisp) · [索引](../README.zh-CN.md)
