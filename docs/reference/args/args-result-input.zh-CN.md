# `han.args:args-result-input`

[English](args-result-input.md)

*访问器*

## 语法

```text
(han.args:args-result-input result) → args-input
(setf (han.args:args-result-input result) new-value) → new-value
```

## 说明

返回参与这次绑定的解析输入。需要复查某条诊断对应的命令、原始 argv 或 token 向量时，可从此字段取得。

## 示例

从绑定结果取回原始 argv。

```lisp
(let ((result
        (han.args:bind-args
         (han.args:parse-args-spec (list (han.args:parse-arg-spec "(--/-j)jobs=1")))
         (han.args:parse-args-input '("demo" "-j" "4")))))
  (han.args:args-input-raw-argv (han.args:args-result-input result)))
;; => ("-j" "4")
```

按诊断索引回查输入对象，展示用户实际传入的未知选项。

```lisp
(let ((result
        (han.args:bind-args
         (han.args:parse-args-spec
          (mapcar #'han.args:parse-arg-spec '()))
         (han.args:parse-args-input '("demo" "--mystery")))))
  (let* ((d (first (han.args:args-result-diagnostics result)))
         (tokens (han.args:args-input-tokens (han.args:args-result-input result))))
    (han.args:arg-token-text (aref tokens (han.args:arg-diagnostic-position d)))))
;; => "--mystery"
```

[`han.args:args-result`](args-result.zh-CN.md) · [`han.args:bind-args`](bind-args.zh-CN.md) · [源码](../../../args/bind.lisp) · [索引](../README.zh-CN.md)
