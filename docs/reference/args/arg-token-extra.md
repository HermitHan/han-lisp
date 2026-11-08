# `han.args:arg-token-extra`

*Accessor · 访问器*

## Syntax · 语法

```text
(han.args:arg-token-extra token) → string or nil
(setf (han.args:arg-token-extra token) new-value) → new-value
```

## Description · 说明

For an option with `=`, return the part after the first equals sign with surrounding space characters trimmed. `--jobs=` yields the empty string. An option without `=` has `nil` here even when the next token supplies its value.

对带 `=` 的选项，返回首个等号后面的部分，并去掉两端的普通空格。`--jobs=` 返回空字符串；选项本身没有等号时返回 `nil`，即使后一项提供了值。

## Examples · 示例

Extract a value attached by an equals sign. 取出选项等号后附带的值。

```lisp
(let ((token
        (aref (han.args:args-input-tokens
               (han.args:parse-args-input '("demo" "--jobs=4")))
              0)))
  (han.args:arg-token-extra token))
;; => "4"
```

Distinguish a missing attached value from an explicitly empty one. 区分没有内联赋值和显式提供空字符串。

```lisp
(let ((input
        (han.args:parse-args-input '("demo" "--name" "--name=" "--name=a=b"))))
  (map 'list #'han.args:arg-token-extra (han.args:args-input-tokens input)))
;; => (nil "" "a=b")
```

[`han.args:arg-token`](arg-token.md) · [`han.args:parse-args-input`](parse-args-input.md) · [Source · 源码](../../../args/lexer.lisp) · [Index · 索引](../README.md)
