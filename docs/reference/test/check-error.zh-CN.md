# `han.test:check-error`

[English](check-error.md)

*宏*

## 语法

```text
(han.test:check-error (condition-type) form*) → t on a matching condition
```

## 说明

执行测试体，捕获指定类型的条件时返回 `t`，其他类型的错误向外传递。即使预期类型就是 `error`，只要测试体正常返回，断言仍会发出 `simple-error`。

## 示例

检查调用方处理非法 JSON 时预期收到的具体条件。

```lisp
(han.test:check-error (han.json:json-error)
  (han.json:parse-json "[1,]"))
;; => T
```

解析成功时，原本期望 JSON 条件的断言会报错。

```lisp
(han.test:check-error (han.json:json-error)
  (han.json:parse-json "true"))
;; signals simple-error
```

测试体发出其他类型的错误时，断言会让原错误继续向外传递。

```lisp
(han.test:check-error (han.json:json-error)
  (error 'type-error :datum :invalid :expected-type 'string))
;; signals type-error
```

即使预期任意错误，正常返回也会使断言失败。

```lisp
(han.test:check-error (error)
  (values :normal-return))
;; signals simple-error
```

[`check-true`](check-true.zh-CN.md) · [`run-test`](run-test.zh-CN.md) · [源码](../../../test/core.lisp#L50) · [索引](../README.zh-CN.md)
