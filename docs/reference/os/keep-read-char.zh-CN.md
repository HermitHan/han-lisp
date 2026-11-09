# `han.os:keep-read-char`

[English](keep-read-char.md)

*函数*

## 语法

```text
(han.os:keep-read-char &optional (stream *standard-input*) (limit nil)) → list of characters
```

## 说明

按顺序读取字符，包括空白与换行。`limit` 为 `nil` 时一直读到 EOF；数值限制表示已读数小于该值时继续。函数限制在每次读前接收逆序累积列表，初次为 `nil`。未消费字符留在原流中。

## 示例

读取前两个字符，把第三个留给下一次读取。

```lisp
(with-input-from-string (input "abc")
  (list (han.os:keep-read-char input 2) (read-char input)))
;; => ((#\a #\b) #\c)
```

按字符消费带分隔符的头部，把后续正文留给另一解码器。

```lisp
(with-input-from-string (in "id:AB")
  (list (coerce (han.os:keep-read-char in
                  (lambda (rev) (not (eql (first rev) #\:)))) 'string)
        (coerce (han.os:keep-read-char in) 'string)))
;; => ("id:" "AB")
```

[`han.os:keep-read-line`](keep-read-line.zh-CN.md) · [`han.os:keep-read`](keep-read.zh-CN.md) · [io.lisp](../../../os/io.lisp) · [索引](../README.zh-CN.md)
