# `han.args:get-arg`

[English](get-arg.md)

*函数*

## 语法

```text
(han.args:get-arg name-or-spec args-result &optional (history nil)) → value, status
```

## 说明

按规格字符串或名称、`arg-spec` 对象或位置整数查询，优先使用内置绑定。未匹配到的键返回两个 `nil`。普通绑定返回值和状态。仅由引用构成的默认值沿用目标的返回值；拼接文本会得到状态为 `:default` 的字符串。递归查询用 `history` 检测循环，发现循环时会报错。应用调用时通常省略它。

## 示例

沿默认引用找到用户输入，并查询一个未声明的键。

```lisp
(let* ((specs (han.args:parse-args-spec
               (mapcar #'han.args:parse-arg-spec '("(--)name" "alias=@name"))))
       (result (han.args:bind-args
                specs (han.args:parse-args-input '("demo" "--name=ada")))))
  (list (multiple-value-list (han.args:get-arg "alias" result))
        (multiple-value-list (han.args:get-arg "unknown" result))))
;; => (("ada" :input) (nil nil))
```

位置编号从零起算时，用整数键查询第二个位置值。

```lisp
(let ((result
        (han.args:bind-args
         (han.args:parse-args-spec
          (mapcar #'han.args:parse-arg-spec '("$0" "$1")))
         (han.args:parse-args-input '("demo" "first" "second")))))
  (han.args:get-arg 1 result))
;; => values ("second" :input)
```

显式传入空字符串时仍会获得输入状态。

```lisp
(let ((result
        (han.args:bind-args
         (han.args:parse-args-spec
          (mapcar #'han.args:parse-arg-spec '("(--)name")))
         (han.args:parse-args-input '("demo" "--name=")))))
  (han.args:get-arg "name" result))
;; => values ("" :input)
```

选项缺省时读取其字面默认值与状态。

```lisp
(let ((result
        (han.args:bind-args
         (han.args:parse-args-spec
          (mapcar #'han.args:parse-arg-spec '("(--)jobs=4")))
         (han.args:parse-args-input '("demo")))))
  (han.args:get-arg "jobs" result))
;; => values ("4" :default)
```

同一选项用长短两种拼法各传一次时，返回值为 `NIL`，状态为 `:conflict`；查询未声明的键则返回两个 `NIL`。

```lisp
(let* ((spec (han.args:parse-args-spec
              (list (han.args:parse-arg-spec "(--/-n)name=world")) "greet"))
       (input (han.args:parse-args-input '("greet" "-n" "Ada" "--name" "Lin")))
       (result (han.args:bind-args spec input)))
  (han.args:get-arg "name" result))
;; => values (NIL :CONFLICT)
```

循环默认引用会在实际查询该参数时触发错误。

```lisp
(defparameter *example-cyclic-result*
  (han.args:bind-args
   (han.args:parse-args-spec
    (mapcar #'han.args:parse-arg-spec '("left=@right" "right=@left")))
   (han.args:parse-args-input '("demo"))))

(han.args:get-arg "left" *example-cyclic-result*)
;; signals simple-error
```

[`han.args:bind-args`](bind-args.zh-CN.md) · [`han.args:arg-binding-status`](arg-binding-status.zh-CN.md) · [源码](../../../args/query.lisp) · [索引](../README.zh-CN.md)
