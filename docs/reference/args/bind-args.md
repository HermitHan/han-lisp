# `han.args:bind-args`

*Function · 函数*

## Syntax · 语法

```text
(han.args:bind-args args-spec args-input &optional builtin-table) → args-result
```

## Description · 说明

Bind a parsed command specification to a parsed invocation. The result retains both inputs and collects lexical warnings, binding errors, and values. Missing required arguments and duplicate single-value options produce diagnostics. If supplied, `builtin-table` must be a hash table of lookup keys to `arg-binding` records with statuses. If omitted, the result contains an empty built-in table.

将命令规格与解析后的输入绑定。结果保留二者并收集词法警告、绑定错误及各参数的值。遗漏必需参数或重复提供单值选项会产生诊断。如提供 `builtin-table`，应传入从查询键映射到带状态 `arg-binding` 记录的哈希表；省略时结果中的内置绑定表为空。

## Examples · 示例

Inspect the result of omitting a required input. 检查遗漏必需输入后返回的绑定及诊断。

```lisp
(let* ((specs (han.args:parse-args-spec
               (list (han.args:parse-arg-spec "!(--/-i)input"))))
       (result (han.args:bind-args specs (han.args:parse-args-input '("demo")))))
  (list (multiple-value-list (han.args:get-arg "input" result))
        (mapcar #'han.args:arg-diagnostic-code
                (han.args:args-result-diagnostics result))))
;; => ((nil :missing) (:missing-required))
```

Duplicate long and short spellings conflict for one single-value option. 同一个单值选项同时用长、短入口提供，会被记为冲突。

```lisp
(let ((result
        (han.args:bind-args
         (han.args:parse-args-spec
          (mapcar #'han.args:parse-arg-spec '("(--/-n)name")))
         (han.args:parse-args-input '("demo" "--name=A" "-n" "B")))))
  (values (multiple-value-list (han.args:get-arg "name" result))
          (mapcar #'han.args:arg-diagnostic-code (han.args:args-result-diagnostics result))))
;; => values ((nil :conflict) (:conflict))
```

Pass a group of arguments through a named slot. 将命名槽中的参数转交给下一个程序，同时保留空字符串。

```lisp
(let ((result
        (han.args:bind-args
         (han.args:parse-args-spec
          (mapcar #'han.args:parse-arg-spec '("(@:)child")))
         (han.args:parse-args-input '("demo" "@child:" "--name" "")))))
  (mapcar #'han.args:arg-token-text (han.args:get-arg "child" result)))
;; => ("--name" "")
```

Use application context ahead of a declared default. 当内置绑定与规格默认值同名，优先取得应用上下文提供的值。

```lisp
(let ((builtins (make-hash-table :test 'equalp))
      (schema (han.args:parse-args-spec (list (han.args:parse-arg-spec "mode=local")))))
  (setf (gethash "mode" builtins)
        (han.args:make-arg-binding :name "mode" :value "cluster" :status :input))
  (han.args:get-arg "mode" (han.args:bind-args schema
                                              (han.args:parse-args-input '("demo")) builtins)))
;; => values ("cluster" :input)
```

[`han.args:get-arg`](get-arg.md) · [`han.args:args-result-diagnostics`](args-result-diagnostics.md) · [Source · 源码](../../../args/bind.lisp) · [Index · 索引](../README.md)
