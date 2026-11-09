# `han.args:args-spec-command`

[English](args-spec-command.md)

*访问器*

## 语法

```text
(han.args:args-spec-command specs) → string
(setf (han.args:args-spec-command specs) new-value) → new-value
```

## 说明

返回传给 `parse-args-spec` 的命令标签，默认是 `"my-args"`。一次调用真正传入的命令字符串可以从 `args-input-raw-cmd` 读取。

## 示例

取回构建命令规格时指定的标签。

```lisp
(let ((specs
        (han.args:parse-args-spec
         (list (han.args:parse-arg-spec "(--/-j)jobs=1")) "report")))
  (han.args:args-spec-command specs))
;; => "report"
```

省略命令标签时可读取默认名称。

```lisp
(han.args:args-spec-command (han.args:parse-args-spec nil))
;; => "my-args"
```

[`han.args:args-spec`](args-spec.zh-CN.md) · [`han.args:parse-args-spec`](parse-args-spec.zh-CN.md) · [源码](../../../args/spec.lisp) · [索引](../README.zh-CN.md)
