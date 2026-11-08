# `han.args:make-args-spec`

*Constructor · 构造器*

## Syntax · 语法

```text
(han.args:make-args-spec &key command args-table) → han.args:args-spec
```

## Description · 说明

Construct and return a fresh `args-spec` with the supplied keyword fields. Omitted fields default to `nil`. Provide an `equalp` hash table keyed by argument name for use with the binder. `parse-args-spec` also checks entry collisions and position numbering.

根据给定的关键字字段创建并返回新的 `args-spec` 对象。省略的字段默认为 `nil`。准备交给绑定器的规格时，可用查询名作为键建立 `equalp` 哈希表。`parse-args-spec` 还会校验入口冲突和位置编号。

## Examples · 示例

Name a command and supply an empty declaration table. 为命令提供标签和空规格表。

```lisp
(let ((specs
        (han.args:make-args-spec
         :command "report" :args-table (make-hash-table :test 'equalp))))
  (han.args:args-spec-command specs))
;; => "report"
```

Bind a manually indexed declaration. 手工建立规格表后，将其交给绑定器。

```lisp
(let ((fields (make-hash-table :test 'equalp)))
  (setf (gethash "file" fields) (han.args:parse-arg-spec "(--)file"))
  (let* ((schema (han.args:make-args-spec :args-table fields :command "list"))
         (result (han.args:bind-args schema
                                     (han.args:parse-args-input '("list" "--file=x")))))
    (han.args:get-arg "FILE" result)))
;; => values ("x" :input)
```

[`han.args:args-spec`](args-spec.md) · [`han.args:args-spec-command`](args-spec-command.md) · [`han.args:parse-args-spec`](parse-args-spec.md) · [Source · 源码](../../../args/spec.lisp) · [Index · 索引](../README.md)
