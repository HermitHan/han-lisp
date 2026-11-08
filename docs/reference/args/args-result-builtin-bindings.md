# `han.args:args-result-builtin-bindings`

*Accessor · 访问器*

## Syntax · 语法

```text
(han.args:args-result-builtin-bindings result) → hash table
(setf (han.args:args-result-builtin-bindings result) new-value) → new-value
```

## Description · 说明

Return the injected binding table checked first by `get-arg`. When the caller omits the third argument of `bind-args`, this is a fresh empty hash table.

返回供 `get-arg` 优先查询的内置绑定表。调用方省略 `bind-args` 的第三个参数时，此处是新建的空哈希表。

## Examples · 示例

Inspect the default empty built-in table. 检查没有注入上下文时的内置表。

```lisp
(let ((result
        (han.args:bind-args
         (han.args:parse-args-spec (list (han.args:parse-arg-spec "(--/-j)jobs=1")))
         (han.args:parse-args-input '("demo" "-j" "4")))))
  (hash-table-count (han.args:args-result-builtin-bindings result)))
;; => 0
```

Retrieve the application-provided table and a contextual key. 取回调用方提供的内置表，并按名称读取上下文值。

```lisp
(let ((table (make-hash-table :test 'equalp)))
  (setf (gethash "site" table)
        (han.args:make-arg-binding :name "site" :value "local" :status :input))
  (let ((result (han.args:bind-args (han.args:parse-args-spec nil)
                                    (han.args:parse-args-input '("demo")) table)))
    (values (eq table (han.args:args-result-builtin-bindings result))
            (han.args:get-arg "SITE" result))))
;; => values (t "local")
```

[`han.args:args-result`](args-result.md) · [`han.args:bind-args`](bind-args.md) · [Source · 源码](../../../args/bind.lisp) · [Index · 索引](../README.md)
