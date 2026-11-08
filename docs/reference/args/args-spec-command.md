# `han.args:args-spec-command`

*Accessor · 访问器*

## Syntax · 语法

```text
(han.args:args-spec-command specs) → string
(setf (han.args:args-spec-command specs) new-value) → new-value
```

## Description · 说明

Return the label supplied to `parse-args-spec`. It defaults to `"my-args"`. To inspect the actual command string from a particular invocation, use `args-input-raw-cmd`.

返回传给 `parse-args-spec` 的命令标签，默认是 `"my-args"`。一次调用真正传入的命令字符串可以从 `args-input-raw-cmd` 读取。

## Examples · 示例

Read the label of a command schema. 取回构建命令规格时指定的标签。

```lisp
(let ((specs
        (han.args:parse-args-spec
         (list (han.args:parse-arg-spec "(--/-j)jobs=1")) "report")))
  (han.args:args-spec-command specs))
;; => "report"
```

Inspect the default label when no command was given. 省略命令标签时可读取默认名称。

```lisp
(han.args:args-spec-command (han.args:parse-args-spec nil))
;; => "my-args"
```

[`han.args:args-spec`](args-spec.md) · [`han.args:parse-args-spec`](parse-args-spec.md) · [Source · 源码](../../../args/spec.lisp) · [Index · 索引](../README.md)
