# `han.os:getenv-default`

*Function · 函数*

## Syntax · 语法

```text
(han.os:getenv-default name default) → environment string or default
```

## Description · 说明

Looks up an environment variable by name. Returns its string value if set, including the empty string, or the supplied fallback object if unset. The fallback need not be a string.

按变量名查询环境。已设置时返回字符串，空字符串也算已设置；未设置时返回调用方提供的默认对象，默认值可以是任意类型。

## Examples · 示例

Use the current environment setting when present and return the keyword `:missing` when it is unset.

环境变量已设置时读取当前值，未设置时返回关键字 `:missing`。

```lisp
(let ((name "HAN_MANUAL_OPTIONAL_VALUE"))
  (equal (han.os:getenv-default name :missing)
         (or (han.host:getenv name) :missing)))
;; => T
```

Preserve an intentionally empty setting while using a non-string default for a missing one.

保留显式设置的空字符串，对缺失项使用非字符串默认值。

```lisp
(nth-value 2
  (han.host:run-program-sync
   (list "/usr/bin/env" "-u" "HAN_DOCS_OPTION" "HAN_DOCS_TAG=" "sbcl" "--noinform" "--no-sysinit" "--no-userinit" "--disable-debugger"
         "--load" (namestring (asdf:system-relative-pathname "han" "load-han.lisp"))
         "--eval" "(assert (equal (list (han.os:getenv-default \"HAN_DOCS_OPTION\" :auto) (han.os:getenv-default \"HAN_DOCS_TAG\" :auto)) '(:auto \"\")))" "--quit")))
;; => 0
```

[`han.os:require-env`](require-env.md) · [`han.host:getenv`](../host/getenv.md) · [env.lisp](../../../os/env.lisp) · [Index · 索引](../README.md)
