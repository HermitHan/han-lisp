# `han.args:args-spec-p`

*Predicate · 谓词*

## Syntax · 语法

```text
(han.args:args-spec-p object) → generalized-boolean
```

## Description · 说明

Recognize a `args-spec` structure. Any Lisp object can be passed. The predicate inspects its type without changing it.

判断传入的 Lisp 对象是否为 `args-spec` 结构。只检查对象类型，调用后对象保持原样。

## Examples · 示例

Recognize the schema for a command with one option. Compare it with an unrelated keyword. 确认单选项命令的整体规格类型。再与无关关键字作对照。

```lisp
(let ((specs
        (han.args:parse-args-spec
         (list (han.args:parse-arg-spec "(--/-j)jobs=1")) "report")))
  (list (han.args:args-spec-p specs) (han.args:args-spec-p :unparsed)))
;; => (t nil)
```

Choose the compiled command schema from mixed setup objects. 从单项声明与整组规格中筛出已组装的命令。

```lisp
(let* ((field (han.args:parse-arg-spec "$1"))
       (models (list field (han.args:parse-args-spec (list field) "report"))))
  (han.args:args-spec-command (find-if #'han.args:args-spec-p models)))
;; => "report"
```

[`han.args:args-spec`](args-spec.md) · [`han.args:parse-args-spec`](parse-args-spec.md) · [Source · 源码](../../../args/spec.lisp) · [Index · 索引](../README.md)
