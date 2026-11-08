# `han.args:arg-binding-name`

*Accessor · 访问器*

## Syntax · 语法

```text
(han.args:arg-binding-name binding) → string or integer
(setf (han.args:arg-binding-name binding) new-value) → new-value
```

## Description · 说明

Return the lookup key for this binding. It is a string for a named argument or an integer for a positional argument. The key is stored independently of the argv spelling used by the caller.

返回此绑定的查询键。命名参数使用字符串，位置参数使用整数。调用者传入的是长选项还是短选项，都用同一个查询名。

## Examples · 示例

Read the canonical key after a short option was used. 输入使用短选项时仍可取回完整的查询名。

```lisp
(let ((binding
        (gethash "jobs"
                 (han.args:args-result-bindings
                  (han.args:bind-args
                   (han.args:parse-args-spec
                    (list (han.args:parse-arg-spec "(--/-j)jobs=1")))
                   (han.args:parse-args-input '("demo" "-j" "4")))))))
  (han.args:arg-binding-name binding))
;; => "jobs"
```

Recover the integer key from a positional binding. 位置绑定保留整数查询名，可以和其字符串值一同读取。

```lisp
(let ((result
        (han.args:bind-args
         (han.args:parse-args-spec
          (mapcar #'han.args:parse-arg-spec '("$1")))
         (han.args:parse-args-input '("demo" "readme.md")))))
  (let ((binding (gethash 1 (han.args:args-result-bindings result))))
    (values (han.args:arg-binding-name binding)
            (han.args:arg-binding-value binding))))
;; => values (1 "readme.md")
```

[`han.args:arg-binding`](arg-binding.md) · [`han.args:get-arg`](get-arg.md) · [Source · 源码](../../../args/bind.lisp) · [Index · 索引](../README.md)
