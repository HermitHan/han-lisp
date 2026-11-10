# `han.host:current-user`

[English](current-user.md)

*函数*

## 语法

```text
(han.host:current-user) → string or nil
```

## 说明

依次读取进程环境中的 `USER` 和 `LOGNAME`，返回首个已设置的值，空字符串也会保留。两个变量都未设置时返回 `nil`。应用可以通过 `han.os:current-user` 指定用于显示的默认名称。

## 示例

读取用户名，为批处理任务指定自己的缺省名称。

```lisp
(equal (or (han.host:current-user) "batch")
       (han.os:current-user "batch"))
;; => T
```

给 Lisp 子进程传入两个不同的账户标签，检查它返回哪一个。

```lisp
(nth-value 2
  (han.host:run-program-sync
   (list "/usr/bin/env" "USER=builder" "LOGNAME=login" #+(or ecl ccl) (first (han.host:argv t)) #-(or ecl ccl) (han.host:find-executable "sbcl")
         #+ecl "--norc" #+ccl "--no-init" #-(or ecl ccl) "--no-userinit"
         #+ecl "--nodebug" #+ccl "--batch" #-(or ecl ccl) "--non-interactive"
         "--load" (namestring (asdf:system-relative-pathname "han" "load-han.lisp"))
         "--eval" "(assert (equal (han.host:current-user) \"builder\"))" "--eval" "(han.host:quit)")))
;; => 0
```

[`han.host:getenv`](getenv.zh-CN.md) · [`han.os:current-user`](../os/current-user.zh-CN.md) · [common.lisp](../../../host/common.lisp) · [索引](../README.zh-CN.md)
