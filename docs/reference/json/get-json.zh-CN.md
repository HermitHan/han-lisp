# `han.json:get-json`

[English](get-json.md)

*函数*

## 语法

```text
(han.json:get-json object key &optional default) → value, present-p
```

## 说明

按字符串键读取对象的一层字段。命中时返回存入的值与 `t`，值本身可以是 `nil` 或 `:null`。键不存在或输入不是对象时返回 `default`（缺省为 `nil`）与 `nil`。对哈希表传入非字符串键会触发 `json-error`。

## 示例

比较显式关闭的设置和使用备用值的缺失字段。

```lisp
(let ((config (han.json:parse-json "{\"retry\":false}")))
  (list (multiple-value-list (han.json:get-json config "retry" :unset))
        (multiple-value-list (han.json:get-json config "limit" :unset))))
;; => ((NIL T) (:UNSET NIL))
```

即使指定了默认值，显式 JSON 空值仍保留自己的值。

```lisp
(han.json:get-json (han.json:parse-json "{\"timeout\":null}") "timeout" 30)
;; => values (:NULL T)
```

嵌套对象本身也可能缺失。继续查询时会返回调用方的默认值，存在标志为假。

```lisp
(let ((record (han.json:json-object)))
  (han.json:get-json (han.json:get-json record "settings") "retry" 3))
;; => values (3 NIL)
```

对象查询用字符串键，整数下标用于向量。

```lisp
(han.json:get-json (han.json:json-object) 0)
;; signals han.json:json-error
```

[`set-json`](set-json.zh-CN.md) · [`json-null-p`](json-null-p.zh-CN.md) · [源码](../../../json/core.lisp#L49) · [索引](../README.zh-CN.md)
