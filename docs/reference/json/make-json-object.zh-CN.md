# `han.json:make-json-object`

[English](make-json-object.md)

*函数*

## 语法

```text
(han.json:make-json-object &optional pairs) → object
```

## 说明

用 cons 列表创建一个采用 `equal` 比较的新哈希表。每个 cons 的 `car` 必须为字符串，整个 `cdr` 就是存入的值。重复键取最后一次出现的值，无效键值对触发 `json-error`。省略列表可创建空对象。

## 示例

用含有重复键的字段列表构造对象。

```lisp
(let* ((fields '(("limit" . 5) ("limit" . 8)))
       (config (han.json:make-json-object fields)))
  (multiple-value-list (han.json:get-json config "limit")))
;; => (8 T)
```

不传字段时可以得到可直接编码的空对象。

```lisp
(han.json:encode-json (han.json:make-json-object) :indent nil)
;; => "{}"
```

字段列表中键为关键字符号时会触发错误。

```lisp
(han.json:make-json-object '((:limit . 5)))
;; signals han.json:json-error
```

[`json-object`](json-object.zh-CN.md) · [`set-json`](set-json.zh-CN.md) · [源码](../../../json/core.lisp#L12) · [索引](../README.zh-CN.md)
