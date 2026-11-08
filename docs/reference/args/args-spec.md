# `han.args:args-spec`

*Structure type · 结构类型*

## Syntax · 语法

```text
han.args:args-spec
(typep object 'han.args:args-spec) → generalized-boolean
```

## Description · 说明

All argument declarations for one command. The table maps their lookup names to individual specifications and is reused across invocations.

一个命令的全部参数声明。表中从查询名映射到各参数的规格，可在同一命令的多次调用之间复用。

## Examples · 示例

Recognize the schema for a command with one option. 确认单选项命令的整体规格类型。

```lisp
(let ((specs
        (han.args:parse-args-spec
         (list (han.args:parse-arg-spec "(--/-j)jobs=1")) "report")))
  (typep specs 'han.args:args-spec))
;; => t
```

Separate a command schema from one of its member declarations. 从混合对象中分别取命令规格的标签和单项规格的查询名。

```lisp
(let* ((item (han.args:parse-arg-spec "(--)size"))
       (schema (han.args:parse-args-spec (list item) "scan")))
  (mapcar (lambda (record)
            (etypecase record
              (han.args:args-spec (han.args:args-spec-command record))
              (han.args:arg-spec (han.args:arg-spec-name record))))
          (list schema item)))
;; => ("scan" "size")
```

[`han.args:args-spec-p`](args-spec-p.md) · [`han.args:make-args-spec`](make-args-spec.md) · [`han.args:parse-args-spec`](parse-args-spec.md) · [Source · 源码](../../../args/spec.lisp) · [Index · 索引](../README.md)
