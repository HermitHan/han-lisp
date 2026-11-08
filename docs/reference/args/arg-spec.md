# `han.args:arg-spec`

*Structure type · 结构类型*

## Syntax · 语法

```text
han.args:arg-spec
(typep object 'han.args:arg-spec) → generalized-boolean
```

## Description · 说明

The declaration for one argument. Its lookup name, entry spellings, arity, and default determine how the binder interprets matching argv items.

单个参数的声明。查询名、入口写法、参数形态和默认值共同决定绑定器怎样处理匹配到的 argv 元素。

## Examples · 示例

Check the type of a parsed option declaration. 确认选项声明解析后的类型。

```lisp
(let ((spec (han.args:parse-arg-spec "!(--/-j)jobs")))
  (typep spec 'han.args:arg-spec))
;; => t
```

Normalize a declaration string and an existing specification in the same schema. 把字符串声明和已建好的规格对象用于同一命令。

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

[`han.args:arg-spec-p`](arg-spec-p.md) · [`han.args:make-arg-spec`](make-arg-spec.md) · [`han.args:parse-arg-spec`](parse-arg-spec.md) · [Source · 源码](../../../args/spec.lisp) · [Index · 索引](../README.md)
