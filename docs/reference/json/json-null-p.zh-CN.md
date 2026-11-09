# `han.json:json-null-p`

[English](json-null-p.md)

*函数*

## 语法

```text
(han.json:json-null-p value) → boolean
```

## 说明

判断 Lisp 值是否为关键字符号 `:null`，即解析 JSON `null` 的结果。JSON `false` 解析为 `nil`。要进一步识别字段缺失，还需检查 `get-json` 返回的存在标志。

## 示例

区分数组里的空值、假值和零。

```lisp
(mapcar #'han.json:json-null-p
        (coerce (han.json:parse-json "[null,false,0]") 'list))
;; => (T NIL NIL)
```

配置可能省略字段时，同时检查存在标志。

```lisp
(let ((record (han.json:parse-json "{\"end\":null}")))
  (flet ((classify (key)
           (multiple-value-bind (value present-p) (han.json:get-json record key)
             (cond ((not present-p) :absent)
                   ((han.json:json-null-p value) :unset)
                   (t :configured)))))
    (list (classify "end") (classify "start"))))
;; => (:UNSET :ABSENT)
```

[`get-json`](get-json.zh-CN.md) · [`parse-json`](parse-json.zh-CN.md) · [源码](../../../json/core.lisp#L35) · [索引](../README.zh-CN.md)
