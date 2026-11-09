# `han.args:arg-binding-value`

[English](arg-binding-value.md)

*访问器*

## 语法

```text
(han.args:arg-binding-value binding) → object
(setf (han.args:arg-binding-value binding) new-value) → new-value
```

## 说明

返回原始绑定值。选项可保存字符串，出现的开关保存 `t`，已提供的块保存 token 列表。默认值里的引用在此仍是表达式，`get-arg` 会按需解析。

## 示例

读取用户传入的原始字符串。

```lisp
(let ((binding
        (gethash "jobs"
                 (han.args:args-result-bindings
                  (han.args:bind-args
                   (han.args:parse-args-spec
                    (list (han.args:parse-arg-spec "(--/-j)jobs=1")))
                   (han.args:parse-args-input '("demo" "-j" "4")))))))
  (han.args:arg-binding-value binding))
;; => "4"
```

比较默认值中尚未展开的引用和查询后的实际字符串。

```lisp
(let ((result
        (han.args:bind-args
         (han.args:parse-args-spec
          (mapcar #'han.args:parse-arg-spec '("name=ada" "alias=@name")))
         (han.args:parse-args-input '("demo")))))
  (let ((binding (gethash "alias" (han.args:args-result-bindings result))))
    (values (han.args:arg-binding-value binding)
            (han.args:get-arg "alias" result))))
;; => values ((:query "name") "ada")
```

[`han.args:arg-binding`](arg-binding.zh-CN.md) · [`han.args:get-arg`](get-arg.zh-CN.md) · [源码](../../../args/bind.lisp) · [索引](../README.zh-CN.md)
