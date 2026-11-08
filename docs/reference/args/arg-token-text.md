# `han.args:arg-token-text`

*Accessor · 访问器*

## Syntax · 语法

```text
(han.args:arg-token-text token) → string
(setf (han.args:arg-token-text token) new-value) → new-value
```

## Description · 说明

Return the complete original argument, including its dashes, slot punctuation, or attached value. Use this field when forwarding a block to another program.

返回原始参数字符串，保留短横线、槽标记和附加值。要将参数块转交给其他程序时，可从这里取回原文。

## Examples · 示例

Recover the spelling passed by the caller. 取回调用者传给程序的选项原文。

```lisp
(let ((token
        (aref (han.args:args-input-tokens
               (han.args:parse-args-input '("demo" "--jobs=4")))
              0)))
  (han.args:arg-token-text token))
;; => "--jobs=4"
```

Forward the original strings in a block, including an empty argument. 转交参数块时保留原始写法、有空格的参数及空字符串。

```lisp
(let ((input
        (han.args:parse-args-input '("demo" "@child:" "--title" "two words" ""))))
  (map 'list #'han.args:arg-token-text (han.args:args-input-tokens input)))
;; => ("@child:" "--title" "two words" "")
```

[`han.args:arg-token`](arg-token.md) · [`han.args:parse-args-input`](parse-args-input.md) · [Source · 源码](../../../args/lexer.lisp) · [Index · 索引](../README.md)
