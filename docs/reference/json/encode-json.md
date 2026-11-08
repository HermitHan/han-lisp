# `han.json:encode-json`

*Function · 函数*

## Syntax · 语法

```text
(han.json:encode-json value &key (indent 2)) → string
```

## Description · 说明

Return a JSON string. The writer sorts object keys by `string<` and uses two spaces per level and a trailing newline by default. `:indent nil` selects compact output without a trailing newline. Supply string-keyed objects, vectors, strings, integers, floats or the literals `t`, `nil`, `:false` and `:null`. Unsupported values such as ratios signal `json-error`. Numbers use the current Lisp printer. When surrounding code customizes number printing, bind `*print-base*` to 10 and `*print-radix*` to `nil` for decimal integers.

返回 JSON 字符串。对象键按 `string<` 排序，默认每层缩进两个空格、末尾带换行。`:indent nil` 输出紧凑文本，末尾没有换行。可编码字符串键对象、向量、字符串、整数、浮点数，以及 `t`、`nil`、`:false`、`:null`。有理分数等不支持的值会触发 `json-error`。数字沿用当前 Lisp 打印设置。若调用环境自定义了进制，写十进制整数时应把 `*print-base*` 绑定为 10、`*print-radix*` 绑定为 `nil`。

## Examples · 示例

Produce compact output with predictable object-key order.

输出紧凑文本，并使用固定的对象键顺序。

```lisp
(han.json:encode-json
 (han.json:json-object (cons "z" nil) (cons "a" (han.json:json-array 1 2)))
 :indent nil)
;; => "{\"a\":[1,2],\"z\":false}"
```

Capture the default pretty layout as separate lines, including the final line break.

按行查看默认缩进格式，并验证末尾有换行。

```lisp
(let ((text (han.json:encode-json (han.json:json-array 2 3))))
  (list (with-input-from-string (in text) (han.os:keep-read-line in))
        (char= (char text (1- (length text))) #\Newline)))
;; => (("[" "  2," "  3" "]") T)
```

An empty vector, a false value and a null value remain distinct on the wire.

空向量、假值和空值在输出文本中仍然可区分。

```lisp
(han.json:encode-json (han.json:json-array (han.json:json-array) nil :null)
                      :indent nil)
;; => "[[],false,null]"
```

Encoding a ratio requires an application decision about how to represent it.

应用需要先决定怎样表示分数，直接编码会报错。

```lisp
(han.json:encode-json 1/3)
;; signals han.json:json-error
```

[`write-json`](write-json.md) · [`write-json-file`](write-json-file.md) · [Source · 源码](../../../json/core.lisp#L505) · [Index · 索引](../README.md)
