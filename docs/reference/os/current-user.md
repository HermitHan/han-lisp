# `han.os:current-user`

*Function · 函数*

## Syntax · 语法

```text
(han.os:current-user &optional (default "World")) → user name or default
```

## Description · 说明

Returns the first available environment string from `USER` and `LOGNAME`. When neither variable is set it returns `default`. The value reflects the process environment rather than a user database lookup.

依次查询环境变量 `USER` 和 `LOGNAME`，返回首个已设置的字符串；都未设置时返回默认值。它读取的是进程环境，不查询系统账户数据库。

## Examples · 示例

Look up the user name in `USER` and then `LOGNAME`, with a fallback when both are unset.

依次按 `USER` 和 `LOGNAME` 查找用户名，两者均未设置时使用备用值。

```lisp
(equal (han.os:current-user :unknown)
       (or (han.host:getenv "USER") (han.host:getenv "LOGNAME") :unknown))
;; => T
```

Run an SBCL child without login variables and supply an explicit name for a batch report.

在移除了登录名变量的 SBCL 子进程中，为批处理报告指定默认用户名。

```lisp
(nth-value 2
  (han.host:run-program-sync
   (list "/usr/bin/env" "-u" "USER" "-u" "LOGNAME" "sbcl" "--noinform" "--no-sysinit" "--no-userinit" "--disable-debugger"
         "--load" (namestring (asdf:system-relative-pathname "han" "load-han.lisp"))
         "--eval" "(assert (string= \"batch\" (han.os:current-user \"batch\")))" "--quit")))
;; => 0
```

[`han.os:getenv-default`](getenv-default.md) · [`han.os:home-directory`](home-directory.md) · [env.lisp](../../../os/env.lisp) · [Index · 索引](../README.md)
