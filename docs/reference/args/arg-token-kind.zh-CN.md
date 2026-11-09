# `han.args:arg-token-kind`

[English](arg-token-kind.md)

*访问器*

## 语法

```text
(han.args:arg-token-kind token) → keyword
(setf (han.args:arg-token-kind token) new-value) → new-value
```

## 说明

返回该元素的词法类别。解析得到的 token 使用 `:long-option`、`:short-option`、`:slot-switch` 或 `:value`。分类在匹配命令规格之前进行。

## 示例

判断带内联值的长选项属于哪一类。

```lisp
(let ((token
        (aref (han.args:args-input-tokens
               (han.args:parse-args-input '("demo" "--jobs=4")))
              0)))
  (han.args:arg-token-kind token))
;; => :long-option
```

在没有命令规格时也能区分选项、槽标记和普通值。

```lisp
(let ((input
        (han.args:parse-args-input '("demo" "-v" "--mode=fast" "@file:" "one"))))
  (map 'list #'han.args:arg-token-kind (han.args:args-input-tokens input)))
;; => (:short-option :long-option :slot-switch :value)
```

[`han.args:arg-token`](arg-token.zh-CN.md) · [`han.args:parse-args-input`](parse-args-input.zh-CN.md) · [源码](../../../args/lexer.lisp) · [索引](../README.zh-CN.md)
