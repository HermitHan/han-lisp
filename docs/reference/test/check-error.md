# `han.test:check-error`

*Macro · 宏*

## Syntax · 语法

```text
(han.test:check-error (condition-type) form*) → t on a matching condition
```

## Description · 说明

Run the body and return `t` when the handler catches the given condition type. An unrelated error from the body propagates. If the body returns normally, the macro raises a `simple-error` inside that same handler. In version 0.1.0 a broad expected type such as `error` or `simple-error` can therefore give a false pass. Choose a specific type that excludes this fallback.

执行测试体，捕获指定类型的条件时返回 `t`。测试体发出的其他类型错误向外传递。若测试体正常结束，宏会在同一处理器的作用域内发出 `simple-error`。因此在 0.1.0 中，用 `error` 或 `simple-error` 等可以捕获兜底错误的类型作预期，可能误报通过。应选择能排除该兜底错误的具体类型。

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

In 0.1.0 an overly broad expected type catches the assertion’s own failure, so this example passes even though the body returned normally.

在 0.1.0 中，过宽的预期类型会捕获断言自己产生的错误。此例的测试体正常返回，断言仍误报通过。

```lisp
(han.test:check-error (error)
  (values :normal-return))
;; => T
```

[`check-true`](check-true.md) · [`run-test`](run-test.md) · [Source · 源码](../../../test/core.lisp#L50) · [Index · 索引](../README.md)
