# `han.args:make-arg-spec`

*Constructor · 构造器*

## Syntax · 语法

```text
(han.args:make-arg-spec &key name long-entry short-entry slot-entry (arity :single) required (visibility :public) default) → han.args:arg-spec
```

## Description · 说明

Construct and return a fresh `arg-spec` with the supplied keyword fields. The default arity is `:single` and visibility is `:public`. The other constructor keywords default to `nil`. Use `parse-arg-spec` to expand shorthand spellings and validate a declaration string.

根据给定的关键字字段创建并返回新的 `arg-spec` 对象。默认形态为 `:single`，可见性为 `:public`，其余关键字参数默认为 `nil`。使用 `parse-arg-spec` 可以展开简写入口并校验规格字符串。

## Examples · 示例

Set both spellings for one required option. 为必需选项同时指定长短写法。

```lisp
(let ((spec
        (han.args:make-arg-spec
         :name "jobs" :long-entry "--jobs" :short-entry "-j" :required t)))
  (han.args:arg-spec-arity spec))
;; => :single
```

Bind a custom long option assembled in Lisp. 直接用 Lisp 构建一个开关声明，然后从命令行读取它。

```lisp
(let* ((field (han.args:make-arg-spec :name "chatty" :long-entry "--verbose" :arity :flag))
       (schema (han.args:parse-args-spec (list field)))
       (result (han.args:bind-args schema (han.args:parse-args-input '("demo" "--verbose")))))
  (han.args:get-arg field result))
;; => values (t :input)
```

[`han.args:arg-spec`](arg-spec.md) · [`han.args:arg-spec-arity`](arg-spec-arity.md) · [`han.args:parse-arg-spec`](parse-arg-spec.md) · [Source · 源码](../../../args/spec.lisp) · [Index · 索引](../README.md)
