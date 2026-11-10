# `han.os:current-user`

[English](current-user.md)

*函数*

## 语法

```text
(han.os:current-user &optional (default "World")) → user name or default
```

## 说明

依次查询环境变量 `USER` 和 `LOGNAME`，返回首个已设置的字符串；都未设置时返回默认值。它读取的是进程环境，不查询系统账户数据库。

## 示例

依次按 `USER` 和 `LOGNAME` 查找用户名，两者均未设置时使用备用值。

```lisp
(equal (han.os:current-user :unknown)
       (or (han.host:getenv "USER") (han.host:getenv "LOGNAME") :unknown))
;; => T
```

在移除了登录名变量的 Lisp 子进程中，为批处理报告指定默认用户名。

```lisp
(nth-value 2
  (han.host:run-program-sync
   (list "/usr/bin/env" "-u" "USER" "-u" "LOGNAME" #+(or ecl ccl) (first (han.host:argv t)) #-(or ecl ccl) (han.host:find-executable "sbcl")
         #+ecl "--norc" #+ccl "--no-init" #-(or ecl ccl) "--no-userinit"
         #+ecl "--nodebug" #+ccl "--batch" #-(or ecl ccl) "--non-interactive"
         "--load" (namestring (asdf:system-relative-pathname "han" "load-han.lisp"))
         "--eval" "(assert (string= \"batch\" (han.os:current-user \"batch\")))" "--eval" "(han.host:quit)")))
;; => 0
```

[`han.os:getenv-default`](getenv-default.zh-CN.md) · [`han.os:home-directory`](home-directory.zh-CN.md) · [env.lisp](../../../os/env.lisp) · [索引](../README.zh-CN.md)
