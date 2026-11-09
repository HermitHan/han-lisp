# `han.args:arg-spec`

[English](arg-spec.md)

*结构类型*

## 语法

```text
han.args:arg-spec
(typep object 'han.args:arg-spec) → generalized-boolean
```

## 说明

单个参数的声明。查询名、入口写法、参数形态和默认值共同决定绑定器怎样处理匹配到的 argv 元素。

## 示例

确认选项声明解析后的类型。

```lisp
(let ((spec (han.args:parse-arg-spec "!(--/-j)jobs")))
  (typep spec 'han.args:arg-spec))
;; => t
```

把字符串声明和已建好的规格对象用于同一命令。

```lisp
(let ((decls (list (han.args:parse-arg-spec "(--)name") "$1")))
  (mapcar (lambda (decl)
            (han.args:arg-spec-name
             (etypecase decl
               (string (han.args:parse-arg-spec decl))
               (han.args:arg-spec decl))))
          decls))
;; => ("name" 1)
```

[`han.args:arg-spec-p`](arg-spec-p.zh-CN.md) · [`han.args:make-arg-spec`](make-arg-spec.zh-CN.md) · [`han.args:parse-arg-spec`](parse-arg-spec.zh-CN.md) · [源码](../../../args/spec.lisp) · [索引](../README.zh-CN.md)
