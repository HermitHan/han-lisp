# `han.host:current-user`

*Function · 函数*

## Syntax · 语法

```text
(han.host:current-user) → string or nil
```

## Description · 说明

Reads `USER` and then `LOGNAME` from the process environment. Returns the first value found, including an empty string. Returns `nil` when both variables are unset. Applications can supply a display name through `han.os:current-user`.

依次读取进程环境中的 `USER` 和 `LOGNAME`，返回首个已设置的值，空字符串也会保留。两个变量都未设置时返回 `nil`。应用可以通过 `han.os:current-user` 指定用于显示的默认名称。

## Examples · 示例

Read the user name with an application-specific fallback for a batch job.

读取用户名，为批处理任务指定自己的缺省名称。

```lisp
(equal (or (han.host:current-user) "batch")
       (han.os:current-user "batch"))
;; => T
```

Start an SBCL child with different account labels and check which one it reports.

给 SBCL 子进程传入两个不同的账户标签，检查它返回哪一个。

```lisp
(nth-value 2
  (han.host:run-program-sync
   (list "/usr/bin/env" "USER=builder" "LOGNAME=login" "sbcl"
         "--noinform" "--no-sysinit" "--no-userinit" "--disable-debugger"
         "--load" (namestring (asdf:system-relative-pathname "han" "load-han.lisp"))
         "--eval" "(assert (equal (han.host:current-user) \"builder\"))" "--quit")))
;; => 0
```

[`han.host:getenv`](getenv.md) · [`han.os:current-user`](../os/current-user.md) · [common.lisp](../../../host/common.lisp) · [Index · 索引](../README.md)
