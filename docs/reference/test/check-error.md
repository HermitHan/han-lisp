# `han.test:check-error`

[简体中文](check-error.zh-CN.md)

*Macro*

## Syntax

```text
(han.test:check-error (condition-type) form*) → t on a matching condition
```

## Description

Run the body and return `t` when the handler catches the given condition type. An unrelated error from the body propagates. If the body returns normally, the assertion signals a `simple-error`, even when the expected type is `error` itself.

## Examples

Assert the concrete condition a caller handles for invalid JSON.

```lisp
(han.test:check-error (han.json:json-error)
  (han.json:parse-json "[1,]"))
;; => T
```

A successful parse fails an assertion expecting a JSON condition.

```lisp
(han.test:check-error (han.json:json-error)
  (han.json:parse-json "true"))
;; signals simple-error
```

An unrelated error from the body passes through the assertion unchanged.

```lisp
(han.test:check-error (han.json:json-error)
  (error 'type-error :datum :invalid :expected-type 'string))
;; signals type-error
```

A normal return fails even a broad assertion that expects any error.

```lisp
(han.test:check-error (error)
  (values :normal-return))
;; signals simple-error
```

[`check-true`](check-true.md) · [`run-test`](run-test.md) · [Source](../../../test/core.lisp#L50) · [Index](../README.md)
