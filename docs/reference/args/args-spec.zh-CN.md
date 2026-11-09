# `han.args:args-spec`

[English](args-spec.md)

*结构类型*

## 语法

```text
han.args:args-spec
(typep object 'han.args:args-spec) → generalized-boolean
```

## 说明

一个命令的全部参数声明。表中从查询名映射到各参数的规格，可在同一命令的多次调用之间复用。

## 示例

确认单选项命令的整体规格类型。

```lisp
(let ((specs
        (han.args:parse-args-spec
         (list (han.args:parse-arg-spec "(--/-j)jobs=1")) "report")))
  (typep specs 'han.args:args-spec))
;; => t
```

从混合对象中分别取命令规格的标签和单项规格的查询名。

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

[`han.args:args-spec-p`](args-spec-p.zh-CN.md) · [`han.args:make-args-spec`](make-args-spec.zh-CN.md) · [`han.args:parse-args-spec`](parse-args-spec.zh-CN.md) · [源码](../../../args/spec.lisp) · [索引](../README.zh-CN.md)
