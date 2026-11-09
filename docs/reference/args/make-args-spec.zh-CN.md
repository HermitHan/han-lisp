# `han.args:make-args-spec`

[English](make-args-spec.md)

*构造器*

## 语法

```text
(han.args:make-args-spec &key command args-table) → han.args:args-spec
```

## 说明

根据给定的关键字字段创建并返回新的 `args-spec` 对象。省略的字段默认为 `nil`。准备交给绑定器的规格时，可用查询名作为键建立 `equalp` 哈希表。`parse-args-spec` 还会校验入口冲突和位置编号。

## 示例

为命令提供标签和空规格表。

```lisp
(let ((specs
        (han.args:make-args-spec
         :command "report" :args-table (make-hash-table :test 'equalp))))
  (han.args:args-spec-command specs))
;; => "report"
```

手工建立规格表后，将其交给绑定器。

```lisp
(let ((fields (make-hash-table :test 'equalp)))
  (setf (gethash "file" fields) (han.args:parse-arg-spec "(--)file"))
  (let* ((schema (han.args:make-args-spec :args-table fields :command "list"))
         (result (han.args:bind-args schema
                                     (han.args:parse-args-input '("list" "--file=x")))))
    (han.args:get-arg "FILE" result)))
;; => values ("x" :input)
```

[`han.args:args-spec`](args-spec.zh-CN.md) · [`han.args:args-spec-command`](args-spec-command.zh-CN.md) · [`han.args:parse-args-spec`](parse-args-spec.zh-CN.md) · [源码](../../../args/spec.lisp) · [索引](../README.zh-CN.md)
