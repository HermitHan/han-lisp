# `han.host:char-unicode-scalar`

[English](char-unicode-scalar.md)

*函数*

## 语法

```text
(han.host:char-unicode-scalar char) → integer or nil
```

## 说明

返回 Lisp 字符对应的 Unicode 标量；映射未知，或者字符对应代理码时返回 `nil`。传入非字符会触发 `type-error`。外部格式需要 Unicode 值时可用此函数：ANSI Common Lisp 不保证 `char-code` 给出的编号就是 Unicode 值。

## 示例

读取一个 ASCII 字符的标量值。

```lisp
(han.host:char-unicode-scalar #\A)
;; => 65
```

在支持 Unicode 的宿主上解析 JSON 代理对，再取出它编码的单个标量值。

```lisp
(let ((text (han.json:parse-json "\"\\uD83D\\uDE00\"")))
  (han.host:char-unicode-scalar (char text 0)))
;; => #x1F600
```

参数必须是字符，即使只有一个字符的字符串也不能直接传入。

```lisp
(han.host:char-unicode-scalar "A")
;; signals type-error
```

[`han.host:unicode-scalar-char`](unicode-scalar-char.zh-CN.md) · [characters.lisp](../../../host/characters.lisp) · [索引](../README.zh-CN.md)
