# `han.args:arg-token-extra`

[English](arg-token-extra.md)

*访问器*

## 语法

```text
(han.args:arg-token-extra token) → string or nil
(setf (han.args:arg-token-extra token) new-value) → new-value
```

## 说明

对带 `=` 的选项，返回首个等号后面的部分，并去掉两端的普通空格。`--jobs=` 返回空字符串；选项本身没有等号时返回 `nil`，即使后一项提供了值。

## 示例

取出选项等号后附带的值。

```lisp
(let ((token
        (aref (han.args:args-input-tokens
               (han.args:parse-args-input '("demo" "--jobs=4")))
              0)))
  (han.args:arg-token-extra token))
;; => "4"
```

区分没有内联赋值和显式提供空字符串。

```lisp
(let ((input
        (han.args:parse-args-input '("demo" "--name" "--name=" "--name=a=b"))))
  (map 'list #'han.args:arg-token-extra (han.args:args-input-tokens input)))
;; => (nil "" "a=b")
```

[`han.args:arg-token`](arg-token.zh-CN.md) · [`han.args:parse-args-input`](parse-args-input.zh-CN.md) · [源码](../../../args/lexer.lisp) · [索引](../README.zh-CN.md)
