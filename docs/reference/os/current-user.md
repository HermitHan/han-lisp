# `han.os:current-user`

[简体中文](current-user.zh-CN.md)

*Function*

## Syntax

```text
(han.os:current-user &optional (default "World")) → user name or default
```

## Description

Returns the first available environment string from `USER` and `LOGNAME`. When neither variable is set it returns `default`. The value reflects the process environment rather than a user database lookup.

## Examples

Look up the user name in `USER` and then `LOGNAME`, with a fallback when both are unset.

```lisp
(equal (han.os:current-user :unknown)
       (or (han.host:getenv "USER") (han.host:getenv "LOGNAME") :unknown))
;; => T
```

Run a child Lisp process without login variables and supply an explicit name for a batch report.

```lisp
(nth-value 2
  (han.host:run-program-sync
   (list "/usr/bin/env" "-u" "USER" "-u" "LOGNAME" #+ecl (first (han.host:argv t)) #-ecl (han.host:find-executable "sbcl")
         #+ecl "--norc" #-ecl "--no-userinit"
         #+ecl "--nodebug" #-ecl "--non-interactive"
         "--load" (namestring (asdf:system-relative-pathname "han" "load-han.lisp"))
         "--eval" "(assert (string= \"batch\" (han.os:current-user \"batch\")))" "--eval" "(han.host:quit)")))
;; => 0
```

[`han.os:getenv-default`](getenv-default.md) · [`han.os:home-directory`](home-directory.md) · [env.lisp](../../../os/env.lisp) · [Index](../README.md)
