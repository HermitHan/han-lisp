# `han.args:arg-spec-slot-entry`

[English](arg-spec-slot-entry.md)

*访问器*

## 语法

```text
(han.args:arg-spec-slot-entry spec) → string or nil
(setf (han.args:arg-spec-slot-entry spec) new-value) → new-value
```

## 说明

返回块的入口字符串，保留 `@` 和末尾的 `:`。简写 `(@:)filter` 声明的是 `@filter:`；普通选项在此字段上为 `nil`。

## 示例

用查询名展开槽入口的简写。

```lisp
(let ((spec (han.args:parse-arg-spec "(@:)filter")))
  (han.args:arg-spec-slot-entry spec))
;; => "@filter:"
```

命令行槽名和程序内部查询名可以分别指定。

```lisp
(let ((spec
        (han.args:parse-arg-spec "(@next:)filter")))
  (values (han.args:arg-spec-name spec) (han.args:arg-spec-slot-entry spec)))
;; => values ("filter" "@next:")
```

[`han.args:arg-spec`](arg-spec.zh-CN.md) · [`han.args:parse-arg-spec`](parse-arg-spec.zh-CN.md) · [源码](../../../args/spec.lisp) · [索引](../README.zh-CN.md)
