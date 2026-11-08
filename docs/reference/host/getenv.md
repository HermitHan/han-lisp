# `han.host:getenv`

*Function · 函数*

## Syntax · 语法

```text
(han.host:getenv name) → string or nil
```

## Description · 说明

Looks up the named environment variable in the running process. An unset variable yields `nil`. An explicitly empty value remains the empty string. Use a string for `name`.

以字符串变量名查询当前进程的环境。未设置时返回 `nil`，已设置为空值时返回空字符串。

## Examples · 示例

Read `HOME` and allow for an environment where it has not been set.

读取环境变量 `HOME`，同时考虑它尚未设置的情况。

```lisp
(let ((value (han.host:getenv "HOME")))
  (or (null value) (stringp value)))
;; => T
```

Distinguish an explicitly empty configuration variable from an unset one in a child SBCL.

在 SBCL 子进程中分别设置空值并移除另一变量，区分空字符串与未设置。

```lisp
(nth-value 2
  (han.host:run-program-sync
   (list "/usr/bin/env" "-u" "HAN_DOCS_ABSENT" "HAN_DOCS_EMPTY=" "sbcl" "--noinform" "--no-sysinit" "--no-userinit" "--disable-debugger"
         "--load" (namestring (asdf:system-relative-pathname "han" "load-han.lisp"))
         "--eval" "(assert (equal (list (han.host:getenv \"HAN_DOCS_EMPTY\") (han.host:getenv \"HAN_DOCS_ABSENT\")) '(\"\" nil)))" "--quit")))
;; => 0
```

[`han.os:getenv-default`](../os/getenv-default.md) · [`han.os:require-env`](../os/require-env.md) · [sbcl.lisp](../../../host/sbcl.lisp) · [lispworks.lisp](../../../host/lispworks.lisp) · [unsupported.lisp](../../../host/unsupported.lisp) · [Index · 索引](../README.md)
