# `han.host:getenv`

[English](getenv.md)

*函数*

## 语法

```text
(han.host:getenv name) → string or nil
```

## 说明

以字符串变量名查询当前进程的环境。未设置时返回 `nil`，已设置为空值时返回空字符串。

## 示例

读取环境变量 `HOME`，同时考虑它尚未设置的情况。

```lisp
(let ((value (han.host:getenv "HOME")))
  (or (null value) (stringp value)))
;; => T
```

在 Lisp 子进程中分别设置空值并移除另一变量，区分空字符串与未设置。

```lisp
(nth-value 2
  (han.host:run-program-sync
   (list "/usr/bin/env" "-u" "HAN_DOCS_ABSENT" "HAN_DOCS_EMPTY=" #+ecl (first (han.host:argv t)) #-ecl (han.host:find-executable "sbcl")
         #+ecl "--norc" #-ecl "--no-userinit"
         #+ecl "--nodebug" #-ecl "--non-interactive"
         "--load" (namestring (asdf:system-relative-pathname "han" "load-han.lisp"))
         "--eval" "(assert (equal (list (han.host:getenv \"HAN_DOCS_EMPTY\") (han.host:getenv \"HAN_DOCS_ABSENT\")) '(\"\" nil)))" "--eval" "(han.host:quit)")))
;; => 0
```

[`han.os:getenv-default`](../os/getenv-default.zh-CN.md) · [`han.os:require-env`](../os/require-env.zh-CN.md) · [sbcl.lisp](../../../host/sbcl.lisp) · [lispworks.lisp](../../../host/lispworks.lisp) · [ecl.lisp](../../../host/ecl.lisp) · [unsupported.lisp](../../../host/unsupported.lisp) · [索引](../README.zh-CN.md)
