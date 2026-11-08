# `han.test:check-error`

*Macro · 宏*

## Syntax · 语法

```text
(han.test:check-error (condition-type) form*) → t on a matching condition
```

## Description · 说明

Run the body and return `t` when the handler catches the given condition type. An unrelated error from the body propagates. If the body returns normally, the assertion signals a `simple-error`, even when the expected type is `error` itself.

执行测试体，捕获指定类型的条件时返回 `t`，其他类型的错误向外传递。即使预期类型就是 `error`，只要测试体正常返回，断言仍会发出 `simple-error`。

## Examples · 示例

Assert the concrete condition a caller handles for invalid JSON.

检查调用方处理非法 JSON 时预期收到的具体条件。

```lisp
(han.test:check-error (han.json:json-error)
  (han.json:parse-json "[1,]"))
;; => T
```

A successful parse fails an assertion expecting a JSON condition.

解析成功时，原本期望 JSON 条件的断言会报错。

```lisp
(han.test:check-error (han.json:json-error)
  (han.json:parse-json "true"))
;; signals simple-error
```

An unrelated error from the body passes through the assertion unchanged.

测试体发出其他类型的错误时，断言会让原错误继续向外传递。

```lisp
(han.test:check-error (han.json:json-error)
  (error 'type-error :datum :invalid :expected-type 'string))
;; signals type-error
```

A normal return fails even a broad assertion that expects any error.

即使预期任意错误，正常返回也会使断言失败。

```lisp
(han.test:check-error (error)
  (values :normal-return))
;; signals simple-error
```

[`check-true`](check-true.md) · [`run-test`](run-test.md) · [Source · 源码](../../../test/core.lisp#L50) · [Index · 索引](../README.md)
