# `han.args:parse-args-spec`

[English](parse-args-spec.md)

*函数*

## 语法

```text
(han.args:parse-args-spec spec-list &optional (command "my-args")) → args-spec
```

## 说明

将 `arg-spec` 列表合并为一个命令规格。同名且相容的声明可以互补字段。字段值冲突、不同查询名占用相同入口、位置编号不连续时会报错。位置编号要从 0 或 1 开始。

## 示例

合并描述同一参数的两条互补规格。

```lisp
(let* ((specs (han.args:parse-args-spec
               (mapcar #'han.args:parse-arg-spec '("(--/-j)jobs" "jobs=4"))
               "report"))
       (jobs (gethash "jobs" (han.args:args-spec-args-table specs))))
  (list (han.args:args-spec-command specs)
        (han.args:arg-spec-short-entry jobs)
        (han.args:arg-spec-default jobs)))
;; => ("report" "-j" "4")
```

两个不同的参数不能占用同一个短选项入口。

```lisp
(defparameter *example-option-declarations*
  (mapcar #'han.args:parse-arg-spec '("(-v)verbose?" "(-v)version?")))

(han.args:parse-args-spec *example-option-declarations*)
;; signals simple-error
```

检查位置参数编号是否连续。

```lisp
(defparameter *example-position-declarations*
  (mapcar #'han.args:parse-arg-spec '("$1" "$3")))

(han.args:parse-args-spec *example-position-declarations*)
;; signals simple-error
```

命令可以使用空规格表，同时保留其名称。

```lisp
(let ((spec (han.args:parse-args-spec nil "version")))
  (values (han.args:args-spec-command spec)
          (hash-table-count (han.args:args-spec-args-table spec))))
;; => values ("version" 0)
```

[`han.args:parse-arg-spec`](parse-arg-spec.zh-CN.md) · [`han.args:args-spec`](args-spec.zh-CN.md) · [源码](../../../args/spec.lisp) · [索引](../README.zh-CN.md)
