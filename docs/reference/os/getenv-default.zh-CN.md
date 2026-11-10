# `han.os:getenv-default`

[English](getenv-default.md)

*函数*

## 语法

```text
(han.os:getenv-default name default) → environment string or default
```

## 说明

按变量名查询环境。已设置时返回字符串，空字符串也算已设置；未设置时返回调用方提供的默认对象，默认值可以是任意类型。

在 ECL 上，长 UTF-8 环境变量值会完整返回。[环境变量查询](../host/getenv.zh-CN.md)

## 示例

环境变量已设置时读取当前值，未设置时返回关键字 `:missing`。

```lisp
(let ((name "HAN_MANUAL_OPTIONAL_VALUE"))
  (equal (han.os:getenv-default name :missing)
         (or (han.host:getenv name) :missing)))
;; => T
```

保留显式设置的空字符串，对缺失项使用非字符串默认值。

```lisp
(nth-value 2
  (han.host:run-program-sync
   (list "/usr/bin/env" "-u" "HAN_DOCS_OPTION" "HAN_DOCS_TAG=" #+(or ecl ccl) (first (han.host:argv t)) #-(or ecl ccl) (han.host:find-executable "sbcl")
         #+ecl "--norc" #+ccl "--no-init" #-(or ecl ccl) "--no-userinit"
         #+ecl "--nodebug" #+ccl "--batch" #-(or ecl ccl) "--non-interactive"
         "--load" (namestring (asdf:system-relative-pathname "han" "load-han.lisp"))
         "--eval" "(assert (equal (list (han.os:getenv-default \"HAN_DOCS_OPTION\" :auto) (han.os:getenv-default \"HAN_DOCS_TAG\" :auto)) '(:auto \"\")))" "--eval" "(han.host:quit)")))
;; => 0
```

[`han.os:require-env`](require-env.zh-CN.md) · [`han.host:getenv`](../host/getenv.zh-CN.md) · [env.lisp](../../../os/env.lisp) · [索引](../README.zh-CN.md)
